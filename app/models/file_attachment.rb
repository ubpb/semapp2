# encoding: utf-8

class FileAttachment < ActiveRecord::Base

  # Relations
  belongs_to :entry, :touch => true
  belongs_to :creator, :class_name => 'User'

  # Behavior
  has_attached_file :file, :styles => {}, :processors => []

  # Validation
  validates_presence_of :entry
  validates_attachment_presence :file

  ################################################################################################
  #
  # Public API
  #
  ################################################################################################
  
  #
  # We will not allow delete on file attachments
  #
  def delete
    destroy
  end

end
