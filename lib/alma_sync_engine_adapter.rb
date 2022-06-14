class AlmaSyncEngineAdapter < SyncEngineAdapter

  def initialize(options = {})
    # noop
  end

  def get_books(ils_user_id)
    books = {}

    loans = get_loans(ils_user_id)

    if loans.present?
      loans.each do |loan|
        mms_id = loan["mms_id"]
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

  def fix_db_entries(db_entries)
    # We need to replace the aleph ils_id for old db_entries with
    # the mms_id from alma.
    db_entries.keys.each do |ils_id|
      mms_id = get_mms_id_for_aleph_id(ils_id)
      book = db_entries[ils_id]

      if mms_id != ils_id
        book.update(ils_id: mms_id)
        db_entries[mms_id] = db_entries.delete(ils_id)
      end
    end

    db_entries
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

  def get_mms_id_for_aleph_id(aleph_id)
    return aleph_id if aleph_id.length > 9 # Already an mms_id

    # For some strange reason the Aleph IDs are missing the leading zeros.
    aleph_id_fixed = aleph_id.to_s.rjust(9, '0')

    sru_url = "https://hbz-pad.alma.exlibrisgroup.com/view/sru/49HBZ_PAD?version=1.2&operation=searchRetrieve&recordSchema=dcx&query=alma.local_field_981=#{aleph_id_fixed}"

    mms_id = nil
    response = RestClient.get(sru_url)
    if response.code == 200
      doc = Nokogiri::XML(response.body).remove_namespaces!
      mms_id = doc.at_xpath("//records/record/recordIdentifier")&.text
    end

    mms_id ? mms_id : aleph_id
  rescue
    aleph_id
  end

end
