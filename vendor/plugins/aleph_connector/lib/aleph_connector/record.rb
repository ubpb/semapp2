require 'xml'

module Aleph
  class Record

    include Aleph::XmlUtils

    def initialize(doc_number, node)
      raise "Doc Number required"                    unless doc_number.present?
      raise "Data is required"                       unless node.present?
      raise "Data must be of type LibXML::XML::Node" unless node.class == LibXML::XML::Node

      @doc_number = doc_number

      data      = LibXML::XML::Document.new()
      data.root = node.copy(true)
      @data     = data
    end

    def doc_number
      @doc_number
    end

    def data
      @data
    end

    #########################################################################################
    #
    # Raw query API
    #
    #########################################################################################

    def fixfield(id)
      content_from_node(@data, "//fixfield[@id=\"#{id}\"]")
    end

    def varfield(id)
      varfield = @data.find_first("//varfield[@id=\"#{id}\"]")
      return nil unless varfield.present?

      result = {:id => nil, :i1 => nil, :i2 => nil, :subfields => {}}

      result[:id] = attribute_from_node(varfield, 'id')
      result[:i1] = attribute_from_node(varfield, 'i1')
      result[:i2] = attribute_from_node(varfield, 'i2')

      varfield.find('subfield').each do |s|
        label   = attribute_from_node(s, 'label')
        content = content_from_node(s)
        if (label and content)
          result[:subfields][label.to_sym] = content
        end
      end

      return result
    end

    def has_fixfield?(id)
      @data.find_first("//fixfield[@id=\"#{id}\"]").present?
    end

    def has_varfield?(id)
      @data.find_first("//varfield[@id=\"#{id}\"]").present?
    end

    #########################################################################################
    #
    # Simple query API
    #
    #########################################################################################

    def title
      # ???
      field_310_a = content_from_node(@data, '//varfield[@id="310"]/subfield[@label="a"]')
      field_310_a.gsub!(/<.*>/, '') if field_310_a.present?
      field_310_a.strip!          if field_310_a.present?
      return field_310_a          if field_310_a.present?

      # title
      field_331_a = content_from_node(@data, '//varfield[@id="331"]/subfield[@label="a"]')
      field_331_a.gsub!(/<.*>/, '') if field_331_a.present?
      field_331_a.strip!          if field_331_a.present?
      return field_331_a          if field_331_a.present?

      # nothing found
      return nil
    end

    def author
      # personal author
      fields = []
      fields[0] = content_from_node(@data, '//varfield[@id="100"]/subfield[@label="a"]')
      fields[1] = content_from_node(@data, '//varfield[@id="100"]/subfield[@label="b"]')
      fields.compact!
      author = fields.join(" ")
      author.gsub!(/<.*>/, '') if author.present?
      return author if author.present?

      # corporate author
      fields = []
      fields[0] = content_from_node(@data, '//varfield[@id="200"]/subfield[@label="a"]')
      fields[1] = content_from_node(@data, '//varfield[@id="200"]/subfield[@label="b"]')
      fields.compact!
      author = fields.join(" ")
      author.gsub!(/<.*>/, '') if author.present?
      return author if author.present?

      # nothing found
      return nil
    end

    def edition
      content_from_node(@data, '//varfield[@id="403"]/subfield[@label="a"]')
    end

    def place
      content_from_node(@data, '//varfield[@id="410"]/subfield[@label="a"]')
    end

    def publisher
      content_from_node(@data, '//varfield[@id="412"]/subfield[@label="a"]')
    end

    def year
      content_from_node(@data, '//varfield[@id="425"]/subfield[@label="a"]')
    end

    def isbn
      content_from_node(@data, '//varfield[@id="540"]/subfield[@label="a"]')
    end

  end
end