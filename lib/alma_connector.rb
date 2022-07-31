class AlmaConnector

  def self.authenticate(user_id, password)
    SemApp2.alma_api.post("users/#{user_id}", params: {password: password})
    true
  rescue ExlApi::LogicalError => e
    false
  end

  def self.resolve_user(user_id)
    response = SemApp2.alma_api.get("users/#{user_id}", format: "application/json")
    UserFactory.build(response)
  rescue ExlApi::LogicalError
    nil
  end

  def self.user_exists?(user_id)
    self.resolve_user(user_id).present?
  end

  def self.get_title_from_alma(title_id)
    SemApp2.alma_api.get("bibs/#{title_id}",
      format: "application/json",
      params: {
        view: "brief"
      }
    )
  rescue ExlApi::LogicalError => e
    nil
  end

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

end
