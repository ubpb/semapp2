class MediaText < ActiveRecord::Base

  # Behavior
  acts_as_media_instance

  # Validation
  validates :text, presence: true

end
