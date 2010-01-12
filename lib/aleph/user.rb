require 'xml'

class Aleph::User

  include Aleph::XmlUtils

  ##
  # Inititalize the object with the given raw data as LibXML::XML::Node
  #
  def initialize(node)
    raise "Node is required"                       unless node.present?
    raise "Node must be of type LibXML::XML::Node" unless node.class == LibXML::XML::Node

    data        = LibXML::XML::Document.new()
    data.root   = node.copy(true)
    @data       = data
    @user_id    = content_from_node(@data, "//z303-id")
    raise "User ID (z303-id) is required" unless @user_id.present?
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

  def user_id
    @user_id
  end

  def data
    @data
  end

  def name
    content_from_node(@data, "//z303-name")
  end

  def email
    content_from_node(@data, "//z304-email-address")
  end

end