require 'xml'

class Aleph::Item

  def initialize(data)
    raise "Data must be of type LibXML::XML::Document or LibXML::XML::Node" unless data.class == LibXML::XML::Document or data.class == LibXML::XML::Node
    @data = data
  end

  def signature
    content_from_node(@data, '//call-no-1')
  end

  def item_status
    content_from_node(@data, '//item-status')
  end

  def loan_status
    content_from_node(@data, '//loan-status')
  end

  def loan_due_date
    t = content_from_node(@data, '//loan-due-date')
    t.present? ? Date.parse(t) : nil
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