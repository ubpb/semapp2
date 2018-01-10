class MediaHeadline < ApplicationRecord

  # Behavior
  acts_as_media_instance

  # Validation
  validates :headline, presence: true

end
