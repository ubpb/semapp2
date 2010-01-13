module Aleph #:nodoc:
  module XmlUtils #:nodoc:

    ##
    # Returns the content from a given node, matched by the given
    # xpath expression. Returns nil if the node is nil or the xpath
    # doesn't match.
    #
    def content_from_node(node, xpath = nil)
      raise "Node must be of type LibXML::XML::Document or LibXML::XML::Node" unless node.class == LibXML::XML::Document or node.class == LibXML::XML::Node
      return nil unless node.present?
      t = xpath ? node.find_first(xpath) : node
      return nil unless t.present?
      return nil unless t.content.present?
      c = t.content
      c.strip!
      c.present? ? c : nil
    end

    ##
    # TODO
    #
    def attribute_from_node(node, attribute)
      raise "Node must be of type LibXML::XML::Document or LibXML::XML::Node" unless node.class == LibXML::XML::Document or node.class == LibXML::XML::Node
      return nil unless node.present?
      t = node.attributes[attribute]
      return nil unless t.present?
      c = t.to_s
      c.strip!
      c.present? ? c : nil
    end

  end
end