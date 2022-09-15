class AlmaSyncEngineAdapter < SyncEngineAdapter

  def initialize(options = {})
    # noop
  end

  def get_ils_books(ils_user_id)
    books = []

    loans = get_loans(ils_user_id)

    if loans.present?
      loans.each do |loan|
        mms_id = loan["mms_id"]
        next if mms_id.blank?

        item_id = loan["item_id"]
        next if item_id.blank?

        bib = get_bib_from_alma(mms_id, item_id)
        next if bib.blank?

        books << {
          ils_id: mms_id,
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

  def fix_db_books(sem_app)
    # We need to replace the aleph ils_id for old db_entries with
    # the mms_id from alma.
    sem_app.books.each do |db_book|
      mms_id = get_mms_id_for_aleph_id(db_book.ils_id)

      if mms_id != db_book.ils_id
        # It is possible that a book with the MMS ID already exists in the db
        # If this is the case we will delete the existing record.
        if existing_book = sem_app.book_by_ils_id(mms_id)
          existing_book.destroy
        end

        # Update the ils_id with the MMS ID from Alma
        db_book.ils_id = mms_id
        db_book.save!
      end
    end
  end

private

  def get_loans(ils_user_id)
    SemApp2.alma_api.get("users/#{ils_user_id}/loans",
      format: "application/json",
      params: {
        limit: 100
      }
    ).try(:[], "item_loan")
  end

  def get_bib_from_alma(mms_id, item_id)
    SemApp2.alma_api.get("bibs/#{mms_id}/holdings/ALL/items/#{item_id}",
      format: "application/json",
      params: {
        view: "brief"
      }
    )
  end

  def get_mms_id_for_aleph_id(aleph_id)
    # For some strange reason the Aleph IDs are missing the leading zeros.
    # Lets fix this.
    aleph_id = aleph_id.rjust(9, '0')

    return aleph_id if aleph_id.length > 9 && aleph_id.starts_with?("99") # Already an mms_id

    sru_url = "https://hbz-pad.alma.exlibrisgroup.com/view/sru/49HBZ_PAD?version=1.2&operation=searchRetrieve&recordSchema=dcx&query=alma.local_field_981=#{aleph_id}"

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
