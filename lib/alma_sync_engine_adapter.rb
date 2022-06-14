class AlmaSyncEngineAdapter < SyncEngineAdapter

  def initialize(options = {})
    # noop
  end

  def get_books(ils_user_id)
    books = {}

    loans = get_loans(ils_user_id)

    if loans.present?
      loans.each do |loan|
        mms_id  = loan["mms_id"]
        next if mms_id.blank?

        item_id = loan["item_id"]
        next if item_id.blank?

        bib = get_bib_from_alma(mms_id, item_id)
        next if bib.blank?

        books[mms_id] = {
          signature: bib.dig("item_data", "alternative_call_number"),
          title: bib.dig("bib_data", "title") || "n.n.",
          author: bib.dig("bib_data", "author") || "n.n.",
          edition: bib.dig("bib_data", "complete_edition"),
          place: bib.dig("bib_data", "place_of_publication"),
          publisher: bib.dig("bib_data", "publisher_const"),
          year: bib.dig("bib_data", "date_of_publication"),
          isbn: bib.dig("bib_data", "isbn")
        }
      end
    end

    return books
  end

private

  def get_loans(ils_user_id)
    SemApp2.alma_api.get("users/#{ils_user_id}/loans",
      format: "application/json",
      params: {
        limit: 100
      }
    ).try(:[], "item_loan")
  rescue ExlApi::LogicalError => e
    puts e.backtrace.join("\n")
    nil
  end

  def get_bib_from_alma(mms_id, item_id)
    SemApp2.alma_api.get("bibs/#{mms_id}/holdings/ALL/items/#{item_id}",
      format: "application/json",
      params: {
        view: "brief"
      }
    )
  rescue ExlApi::LogicalError => e
    puts e.backtrace.join("\n")
    nil
  end

end
