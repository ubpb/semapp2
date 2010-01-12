require 'net/http'
require 'xml'

class Aleph::Connector

  include Aleph::XmlUtils

  @@base_url    = nil # The Alpeh base url. E.g. http://ubaleph.uni-paderborn.de/X
  @@library     = nil # The library to use. E.g. pad50
  @@search_base = nil # The Aleph search base. E.g. pad01

  cattr_accessor :base_url, :library, :search_base

  def initialize(options = {})
    @base_url    = options[:base_url].present?    ? options[:base_url]    : @@base_url
    @library     = options[:library].present?     ? options[:library]     : @@library
    @search_base = options[:search_base].present? ? options[:search_base] : @@search_base

    raise "base_url option missing"    unless @@base_url.present?
    raise "library option missing"     unless @@library.present?
    raise "search_base option missing" unless @@search_base.present?
  end

  def get_lendings(ils_account_no)
    load_lendings(ils_account_no, @library)
  end

  def get_record(doc_number)
    load_record(doc_number, @search_base)
  end

  def get_item(doc_number)
    load_item(doc_number, @search_base)
  end

  def find(term)
    do_find(term)
  end

  def get_records(set_number, page = 1, page_size = 10)
    set_number = set_number[0] if set_number.is_a?(Array)
    load_records(set_number, page, page_size)
  end

  private

  ##
  # Returns a list of Aleph document numbers that are
  # currently lent by the given ils account number in
  # the given library.
  #
  def load_lendings(ils_account_no, library)
    url  = "#{@base_url}?op=bor-info&bor_id=#{ils_account_no}&library=#{library}"
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
    url  = "#{@base_url}?op=find-doc&doc_num=#{doc_number}&base=#{search_base}"
    data = load_url(url)
    node = data.find_first('//find-doc/record')
    return Aleph::Record.new(doc_number, node) if node.present?
  end

  def load_item(doc_number, search_base)
    url  = "#{@base_url}?op=item-data&doc_num=#{doc_number}&base=#{search_base}"
    data = load_url(url)
    node = data.find_first('//item-data/item')
    return Aleph::Item.new(doc_number, node) if node.present?
  end

  def do_find(term)
    url  = "#{@base_url}?op=find&base=pad01&request=#{URI.escape(term)}"
    data = load_url(url)

    set_number = content_from_node(data, '//set_number')
    return nil unless set_number
    no_records = content_from_node(data, '//no_records')
    return nil unless no_records

    return set_number, no_records.to_i
  end

  def load_records(set_number, page, page_size)
    page_size = 100 if page_size > 100
    page_size = 10  if page_size < 1
    start_entry = (page * page_size) - page_size + 1
    stop_entry  = (page * page_size)

    url  = "#{@base_url}?op=present&set_number=#{set_number}&set_entry=#{start_entry}-#{stop_entry}"
    data = load_url(url)

    records = []
    data.find('//present/record').each do |r|
      records << Aleph::Record.new(content_from_node(r, 'doc_number'), r)
    end

    return records
  end

  ##
  # Loads the given Aleph url and parses the XML result into
  # a LibXML::XML::Document.
  #
  def load_url(url)
    XML::Parser.string(Net::HTTP.get_response(URI.parse(url)).body).parse
  end

end
