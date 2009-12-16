class Attachment < ActiveRecord::Base

  belongs_to        :sem_app_entry
  has_attached_file :attachable, :styles => {}

  validates_attachment_presence :attachable

end
