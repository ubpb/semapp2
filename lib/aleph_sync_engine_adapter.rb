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
    books = {}

    if lendings.present?  
      lendings.each do |l|
        sleep(1/100)
        books[l[:doc_number]] = {
          :signature  => l[:signature],
          :title      => l[:title],
          :author     => l[:author],
          :year       => l[:year],
          :edition    => l[:edition],
          :place      => l[:place],
          :publisher  => l[:publisher],
          :isbn       => l[:isbn]
        }
      end
    end

    return books
  end

end
