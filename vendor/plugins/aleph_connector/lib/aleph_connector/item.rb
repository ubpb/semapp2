# encoding: utf-8

module Aleph
  class Item

    include Aleph::XmlUtils

    ##
    # Inititalize the object with the given raw data in XML format
    #
    def initialize(doc_number, node)
      raise "Doc Number required" unless doc_number.present?
      raise "Node is required"    unless node.present?

      @doc_number = doc_number.to_i.to_s
      d      = Nokogiri::XML::Document.new
      d.root = node.dup
      @data       = d
    end

    def doc_number
      @doc_number
    end

    ##
    # Return the raw XML object
    #
    def data
      @data
    end

    ##
    # Most of the item data can be called using method missing
    #
    def method_missing(m, *args, &block)
      method_name = m.to_s
      method_name = method_name.gsub('_', '-')
      content_from_node(@data, "//#{method_name}")
    end

    ##
    # Return a proper Date object for load_due_date
    #
    def loan_due_date
      t = content_from_node(@data, '//loan-due-date')
      t.present? ? Date.parse(t) : nil
    end

  end
end