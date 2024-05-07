class AlmaConnector

  class UserFactory
    def self.build(user_data)
      OpenStruct.new({
        primary_id: user_data["primary_id"],
        login: user_data["user_identifier"].find{|id| id.dig("id_type", "value") == "01"}&.dig("value")&.upcase || user_data["primary_id"],
        name: user_data["full_name"],
        email: user_data["contact_info"]["email"].find{|email| email.dig("preferred") == true}&.dig("email_address"),
        user_group: user_data.dig("user_group", "value")
      })
    end
  end

  def self.authenticate(user_id, password)
    SemApp2.alma_api.post("users/#{user_id}", params: {password: password})
    true
  rescue AlmaApi::LogicalError
    false
  end

  def self.resolve_user(user_id)
    response = SemApp2.alma_api.get("users/#{user_id}", format: "json")
    UserFactory.build(response)
  rescue AlmaApi::LogicalError
    nil
  end

  def self.user_exists?(user_id)
    self.resolve_user(user_id).present?
  end

  def self.get_title(record_id)
    title = SemApp2.alma_api.get("bibs/#{record_id}",
      format: :json,
      params: {
        view: "brief"
      }
    )

    if (items = self.get_items(record_id)).present?
      # Get call number for each item
      call_numbers = items.map{|i| i.dig("item_data", "alternative_call_number")}
      # Calculate base call number
      call_numbers = call_numbers.map do |call_number|
        index = call_number.index("+") || call_number.length
        call_number[0..index-1].presence
      end
      # Dedup
      call_numbers = call_numbers.map(&:presence).compact.uniq
      # Set call_number in title
      # TODO: Handle case if there is more than one call number
      title["call_number"] = call_numbers.first
    end

    title
  rescue AlmaApi::LogicalError => e
    nil
  end

  def self.get_items(record_id)
    # Alma uses offset and limit for pagination
    offset = 0
    limit  = 100

    # Load the first 100 items from Alma
    response = self.load_items(record_id, offset: offset, limit: limit)
    # Get total number of items
    total_number_of_items = response["total_record_count"] || 0

    # Build array of item objects
    items = []
    items += response["item"] || []

    # Fetch the rest if there are more items
    if limit < total_number_of_items
      while (offset = offset + limit) < total_number_of_items
        response = load_items(record_id, offset: offset, limit: limit)
        items += response["item"] || []
      end
    end

    # Filter out items with we don't want in discovery
    items = items.reject do |i|
      # Unassigned holdings
      i.dig("item_data", "location", "value") =~ /UNASSIGNED/ ||
      # Items that are suppressed from publishing
      # For whatever reason this boolean flag is of type string.
      i.dig("holding_data", "holding_suppress_from_publishing") == "true" ||
      # Items at location LL (Ausgesondert)
      i.dig("item_data", "location", "value") == "LL"
    end
  end

  def self.load_items(record_id, limit:, offset:)
    SemApp2.alma_api.get(
      "bibs/#{record_id}/holdings/ALL/items",
      format: :json,
      params: {
        #expand: "due_date_policy,due_date",
        limit: limit,
        offset: offset
      }
    )
  rescue
    {}
  end

end
