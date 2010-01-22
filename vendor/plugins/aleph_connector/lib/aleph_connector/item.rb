require 'xml'

module Aleph
  class Item

    include Aleph::XmlUtils

    ##
    # Inititalize the object with the given raw data as LibXML::XML::Node
    #
    def initialize(doc_number, node)
      raise "Doc Number required"                    unless doc_number.present?
      raise "Node is required"                       unless node.present?
      raise "Node must be of type LibXML::XML::Node" unless node.class == LibXML::XML::Node

      @doc_number = doc_number.to_i.to_s

      data        = LibXML::XML::Document.new()
      data.root   = node.copy(true)
      @data       = data
    end

    def doc_number
      @doc_number
    end

    ##
    # Return the raw LibXML::XML::Node object
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