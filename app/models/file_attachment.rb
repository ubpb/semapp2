class FileAttachment < ApplicationRecord

  # Relations
  belongs_to :media,   :touch => true
  belongs_to :creator, :class_name => 'User', optional: true

  # Behavior
  has_attached_file :file, :styles => {}, :processors => []
  validates_attachment_file_name :file, matches: [/\.[a-zA-Z0-9]+\z/], message: "Datei hat keine Dateiendung."
  do_not_validate_attachment_file_type :file

  # Validation
  validates_presence_of :media
  validates_attachment_presence :file
  validates_acceptance_of :accepts_copyright

  # virtuell attributes
  attr_accessor :accepts_copyright

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
