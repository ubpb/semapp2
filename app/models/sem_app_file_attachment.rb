# == Schema Information
# Schema version: 20090729092414
#
# Table name: sem_app_file_attachments
#
#  id                      :integer(4)      not null, primary key
#  attachable_id           :integer(4)      not null
#  attachable_type         :string(255)     not null
#  attachment_file_name    :string(255)     not null
#  attachment_content_type :string(255)     not null
#  attachment_file_size    :string(255)     not null
#  created_at              :datetime
#  updated_at              :datetime
#

class SemAppFileAttachment < ActiveRecord::Base

  belongs_to :attachable, :polymorphic => true

  has_attached_file :attachment, :styles => {}, :processors => []

end
