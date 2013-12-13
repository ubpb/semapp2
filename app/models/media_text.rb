class MediaText < ActiveRecord::Base

  # Behavior
  acts_as_media_instance

  # Validation
  validates :text, presence: true


  def to_be_published
    self.publish_on.present? and self.publish_on >= Time.new
  end

end
