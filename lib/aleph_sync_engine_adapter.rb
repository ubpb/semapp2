# encoding: utf-8

class AlephSyncEngineAdapter < SyncEngineAdapter

  def initialize(options = {})
    @base_url    = options[:base_url]
    @library     = options[:library]
    @search_base = options[:search_base]

    @aleph = Aleph::Connector.new(:base_url => @base_url, :library => @library, :search_base => @search_base)
  end

  def get_books(ils_account)
    lendings = @aleph.get_lendings(ils_account)
    if lendings.present?
      books = {}
      lendings.each do |l|
        sleep(1/100)
        record = @aleph.get_record(l[:doc_number])
        item   = @aleph.get_item(l[:doc_number], l[:barcode])

        if record.present? and item.present?
          books[record.doc_number] = {
            :signature  => item.call_no_1,
            :title      => record.title,
            :author     => record.author,
            :year       => record.year,
            :edition    => record.edition,
            :place      => record.place,
            :publisher  => record.publisher,
            :isbn       => record.isbn,
          }
        end
      end
      return books
    else
      return {}
    end
  end

  private

  

end
