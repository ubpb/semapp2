require 'net/http'
require 'xml'

class Aleph::Connector < AbstractConnector

  def initialize(options = {})
    @options = options
    raise "aleph_base_url option missing" unless @options[:aleph_base_url].present?
    raise "library option missing"        unless @options[:library].present?
    raise "search_base option missing"    unless @options[:search_base].present?
  end

  def get_lendings(ils_account_no)
    lendings = load_lendings(ils_account_no, @options[:library])
  end

  def get_record(doc_number)
    load_record(doc_number, @options[:search_base])
  end

  def get_item(doc_number)
    load_item(doc_number, @options[:search_base])
  end

  #######################################################################################

  def get_books(ils_account)
    url = "#{@options[:aleph_base_url]}?op=bor-info&bor_id=#{ils_account}&library=pad50"
    xml = Net::HTTP.get_response(URI.parse(url)).body
    doc = XML::Parser.string(xml).parse

    books = {}
    doc.find('//bor-info/item-l').each do |item|
      book = {}
      book[:title]     = content_from_node(item, 'z13/z13-title')
      book[:author]    = content_from_node(item, 'z13/z13-author')
      book[:edition]   = content_from_node(item, 'z13/z13-user-defined-1')
      book[:place]     = content_from_node(item, 'z13/z13-imprint')
      book[:publisher] = nil # TODO: How do we get the publisher out of Alpeh XServer
      book[:year]      = content_from_node(item, 'z13/z13-year')
      book[:isbn]      = content_from_node(item, 'z13/z13-isbn-issn')
      
      signature = content_from_node(item, 'z13/z13-call-no')
      books[signature] = book
    end
    return books
  end

  def find_book_by_signature(signature)
    find_url   = "#{@options[:aleph_base_url]}?op=find&code=PSG&request=#{signature}&base=pad01"
    set_number = content_from_node(load_url(find_url), '//set_number')
    
    present_url = "#{@options[:aleph_base_url]}?op=present&set_number=#{set_number}&set_entry=1"
    data        = load_url(present_url)
    doc_number  = content_from_node(data, '//record/doc_number')

    item_url       = "#{@options[:aleph_base_url]}?op=item-data&doc_num=#{doc_number}&base=pad01"
    item_data      = load_url(item_url)
    real_signature = content_from_node(item_data, '//item/call-no-1')
    
    data        = data.find_first('//record/metadata/oai_marc')

    book_from_data(doc_number, real_signature, data)
  end

  private

  ##
  # Returns a list of Aleph document numbers that are
  # currently lent by the given ils account number in
  # the given library.
  #
  def load_lendings(ils_account_no, library)
    url  = "#{@options[:aleph_base_url]}?op=bor-info&bor_id=#{ils_account_no}&library=#{library}"
    data = load_url(url)

    lendings = []
    data.find('//bor-info/item-l').each do |l|
      lendings << content_from_node(l, 'z13/z13-doc-number')
    end

    return lendings.compact
  end

  ##
  # Returns the Aleph record with the given document number.
  #
  def load_record(doc_number, search_base)
    url  = "#{@options[:aleph_base_url]}?op=find-doc&doc_num=#{doc_number}&base=#{search_base}"
    data = load_url(url)
    return Aleph::Record.new(data.find_first('//find-doc/record'))
  end

  def load_item(doc_number, search_base)
    url = "#{@options[:aleph_base_url]}?op=item-data&doc_num=#{doc_number}&base=#{search_base}"
    data = load_url(url)
    return Aleph::Item.new(data.find_first('//item-data/item'))
  end

  ##
  # Loads the given Aleph url and parses the XML result into
  # a LibXML::XML::Document.
  #
  def load_url(url)
    XML::Parser.string(Net::HTTP.get_response(URI.parse(url)).body).parse
  end

  ##
  # Returns the content from a given node, matched by the given
  # xpath expression. Returns nil if the node is nil or the xpath
  # doesn't match.
  #
  def content_from_node(node, xpath)
    raise "Node must be of type LibXML::XML::Document or LibXML::XML::Node" unless node.class == LibXML::XML::Document or node.class == LibXML::XML::Node
    return nil unless node.present?
    t = node.find_first(xpath)
    t.present? ? t.content : nil
  end

end
