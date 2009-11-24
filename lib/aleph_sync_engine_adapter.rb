class AlephSyncEngineAdapter < SyncEngineAdapter

  def initialize(options)
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
        sleep(0.3)
        record = @aleph.get_record(l)
        item   = @aleph.get_item(l)
        if record.present? and item.present?
          books[record.doc_number.to_sym] = {
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
    end
  end

end
