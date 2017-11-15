# encoding: utf-8

module Aleph
  class User

    include Aleph::XmlUtils

    ##
    # Inititalize the object with the given raw data as LibXML::XML::Node
    #
    def initialize(node)
      raise "Node is required" unless node.present?

      d      = Nokogiri::XML::Document.new
      d.root = node.dup
      @data  = d
    end

    #########################################################################################
    #
    # Raw query API
    #
    #########################################################################################

    ##
    # Most of the item data can be called using method missing
    #
    def method_missing(m, *args, &block)
      method_name = m.to_s
      method_name = method_name.gsub('_', '-')
      content_from_node(@data, "//#{method_name}")
    end

    #########################################################################################
    #
    # Simple query API
    #
    #########################################################################################

    def login
      content_from_node(@data, "//z308[z308-key-type=01]/z308-key-data")
    end

    def data
      @data
    end

    def id
      content_from_node(@data, "//z303-id")
    end

    def name
      content_from_node(@data, "//z303-name")
    end

    def email
      @data.xpath("//z304-email-address").map{|n| n.text.presence}.compact.first
    end

    def status
      content_from_node(@data, "//z305-bor-status")
    end

    def ban_codes
      [
        content_from_node(@data, "//z303-delinq-1"),
        content_from_node(@data, "//z303-delinq-2"),
        content_from_node(@data, "//z303-delinq-3")
      ]
    end

  end
end
