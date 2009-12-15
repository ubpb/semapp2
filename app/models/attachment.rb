class Attachment < ActiveRecord::Base

  belongs_to        :sem_app_entry
  has_attached_file :attachable, :styles => {}

  validates_presence_of :title
  validates_attachment_presence :attachable

end
