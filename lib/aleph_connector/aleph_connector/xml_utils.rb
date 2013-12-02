# encoding: utf-8

module Aleph #:nodoc:
  module XmlUtils #:nodoc:

    def content_from_node(node, xpath = nil)
      return nil unless node.present?
      
      t = xpath ? node.xpath(xpath)[0] : node
      return nil unless t.present?
      return nil unless t.content.present?
      c = t.content
      c.strip!
      c.present? ? c : nil
    end

    def attribute_from_node(node, attribute)
      return nil unless node.present?
      t = node[attribute]
      return nil unless t.present?
      c = t.to_s
      c.strip!
      c.present? ? c : nil
    end

  end
end