require 'xml'

class Aleph::Record

  def initialize(data)
    raise "Data must be of type LibXML::XML::Document or LibXML::XML::Node" unless data.class == LibXML::XML::Document or data.class == LibXML::XML::Node
    @data = data
  end

  def doc_number
    content_from_node(@data, '//doc_number')
  end

  def title
    # ???
    field_310_a = content_from_node(@data, '//varfield[@id="310"]/subfield[@label="a"]')
    return field_310_a if field_310_a.present?

    # title
    field_331_a = content_from_node(@data, '//varfield[@id="331"]/subfield[@label="a"]')
    return field_331_a if field_331_a.present?

    # nothing found
    return nil
  end

  def author
    # personal author
    fields = []
    fields[0] = content_from_node(@data, '//varfield[@id="100"]/subfield[@label="a"]')
    fields[1] = content_from_node(@data, '//varfield[@id="100"]/subfield[@label="b"]')
    author = fields.join(" ")
    return author if author.present?

    # corporate author
    fields = []
    fields[0] = content_from_node(@data, '//varfield[@id="200"]/subfield[@label="a"]')
    fields[1] = content_from_node(@data, '//varfield[@id="200"]/subfield[@label="b"]')
    author = fields.join(" ")
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

  private

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