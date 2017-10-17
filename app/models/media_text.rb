class MediaText < ApplicationRecord

  # Behavior
  acts_as_media_instance

  # Validation
  validates :text, presence: true

end
