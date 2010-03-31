# encoding: utf-8

class FileAttachment < ActiveRecord::Base

  # Relations
  belongs_to :entry #, :touch => true
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

  ################################################################################################
  #
  # AR Callbacks
  #
  ################################################################################################

  def after_save
    if self.entry
      touch_object(self.entry)
    end
  end

  def before_destroy
    if self.entry
      touch_object(self.entry)
    end
  end

  def touch_object(object)
    current_time = current_time_from_proper_timezone

    object.write_attribute('updated_at', current_time) if object.respond_to?(:updated_at)
    object.write_attribute('updated_on', current_time) if object.respond_to?(:updated_on)

    object.save(false)
  end

  def current_time_from_proper_timezone
    self.class.default_timezone == :utc ? Time.now.utc : Time.now
  end

end
