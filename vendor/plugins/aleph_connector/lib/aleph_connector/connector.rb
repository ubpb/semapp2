# encoding: utf-8

require 'net/http'
require 'xml'

module Aleph #:nodoc:

  ##
  # TODO
  #
  class Connector

    include Aleph::XmlUtils

    @@base_url           = 'http://localhost/X'
    @@library            = 'lib50'
    @@search_base        = 'lib01' 
    @@allowed_user_types = [/^PA.+/, /^PS.+/]
    @@allowed_ban_codes  = [/^00$/]

    cattr_accessor :base_url, :library, :search_base, :allowed_user_types, :allowed_ban_codes

    def initialize(options = {})
      @base_url           = options[:base_url].present?           ? options[:base_url]           : @@base_url
      @library            = options[:library].present?            ? options[:library]            : @@library
      @search_base        = options[:search_base].present?        ? options[:search_base]        : @@search_base
      @allowed_user_types = options[:allowed_user_types].present? ? options[:allowed_user_types] : @@allowed_user_types
      @allowed_ban_codes  = options[:allowed_ban_codes].present?  ? options[:allowed_ban_codes]  : @@allowed_ban_codes

      [@allowed_user_types, @allowed_ban_codes].each do |o|
        o.instance_eval do
          def allows?(s)
            self.map{|m| m.match(s)}.select{|x|x}.length > 0
          end
        end
      end
    end

    def authenticate(ils_account_no, verification)
      do_authenticate(ils_account_no, verification)
    end

    def get_lendings(ils_account_no)
      load_lendings(ils_account_no)
    end

    def get_record(doc_number)
      load_record(doc_number)
    end

    def get_item(doc_number, barcode)
      load_item(doc_number, barcode)
    end

    def get_items(doc_number)
      load_items(doc_number)
    end

    def get_base_signature(doc_number)
      load_base_signature(doc_number)
    end

    def get_signature(doc_number)
      load_signature(doc_number)
    end

    def find(term)
      do_find(term)
    end

    def get_records(set_number, page = 1, page_size = 10)
      set_number = set_number[0] if set_number.is_a?(Array)
      load_records(set_number, page, page_size)
    end

    private

    def do_authenticate(ils_account_no, verification)
      raise "Account No. required" if ils_account_no.blank?
      raise "Password required" if verification.blank?

      ils_account_no.gsub!(/\s/, '')
      ils_account_no.upcase!

      url  = "#{@base_url}?op=bor-auth&bor_id=#{ils_account_no}&verification=#{verification}&library=#{@library}"
      data = load_url(url)

      if data.find_first('/bor-auth/error')
        raise Aleph::AuthenticationError, "Authentication failed"
      else
        user = Aleph::User.new(ils_account_no, data.find_first('/bor-auth'))

        unless @allowed_user_types.allows?(user.status)
          raise Aleph::UnsupportedAccountTypeError, "Authentication not allowed. Wrong user type."
        end
        
        unless user.ban_codes.all?{|code| @allowed_ban_codes.allows?(code)}
          raise Aleph::AccountLockedError, "Authentication not allowed. Your account is locked."
        end

        return user
      end
    end

    ##
    # Returns a list of Aleph document numbers that are
    # currently lent by the given ils account number in
    # the given library.
    #
    def load_lendings(ils_account_no)
      url  = "#{@base_url}?op=bor-info&bor_id=#{ils_account_no}&library=#{@library}"
      data = load_url(url)

      # Check for error
      error = content_from_node(data, '//bor-info/error')
      raise "#{ils_account_no}: #{error}" if error.present?

      lendings = []
      data.find('//bor-info/item-l').each do |l|
        lendings << {
          :doc_number => content_from_node(l, 'z13/z13-doc-number'),
          :barcode    => content_from_node(l, 'z30/z30-barcode')
        }
      end

      return lendings.compact
    end

    ##
    # Returns the Aleph record with the given document number.
    #
    def load_record(doc_number)
      url  = "#{@base_url}?op=find-doc&doc_num=#{doc_number}&base=#{@search_base}"
      data = load_url(url)
      node = data.find_first('//find-doc/record')
      return Aleph::Record.new(doc_number, node) if node.present?
    end

    def load_items(doc_number)
      url  = "#{@base_url}?op=item-data&doc_num=#{doc_number}&base=#{@search_base}"
      data = load_url(url)
      items = []
      data.find('//item-data/item').each do |item|
        items << Aleph::Item.new(doc_number, item)
      end

      return items
    end

    def load_item(doc_number, barcode)
      items = load_items(doc_number)
      items.each do |item|
        return item if item.barcode == barcode
      end
      return nil
    end

    def load_base_signature(doc_number)
      signature = load_signature(doc_number)
      return signature.gsub(/\+.+/, '') if signature.present?
    end

    def load_signature(doc_number)
      items = load_items(doc_number)
      items.each do |item|
        signature = item.call_no_1
        return signature if signature.present?
      end
      return nil
    end

    def do_find(term)
      url  = "#{@base_url}?op=find&base=#{@search_base}&request=#{URI.escape(term)}"
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

  ##
  # TODO
  #
  class AuthenticationError < RuntimeError
  end

  ##
  # TODO
  #
  class UnsupportedAccountTypeError < RuntimeError
  end

  ##
  # TODO
  #
  class AccountLockedError < RuntimeError
  end
  
end