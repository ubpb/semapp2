# == Schema Information
# Schema version: 20091110135349
#
# Table name: attachments
#
#  id                      :integer         not null, primary key
#  sem_app_entry_id        :integer         not null
#  attachable_file_name    :string(255)     not null
#  attachable_content_type :string(255)     not null
#  attachable_file_size    :integer         not null
#  description             :text
#

class Attachment < ActiveRecord::Base

  belongs_to        :entry
  has_attached_file :attachable, :styles => {}

  validates_attachment_presence :attachable

end
