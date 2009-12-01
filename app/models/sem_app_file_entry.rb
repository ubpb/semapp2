# == Schema Information
# Schema version: 20091110135349
#
# Table name: sem_app_file_entries
#
#  id                      :integer(4)      not null, primary key
#  attachment_file_name    :string(255)     not null
#  attachment_content_type :string(255)     not null
#  attachment_file_size    :integer(4)      not null
#  title                   :string(255)     not null
#  description             :text
#  created_at              :datetime
#  updated_at              :datetime
#

class SemAppFileEntry < ActiveRecord::Base

  belongs_to :sem_app
  has_attached_file :attachment, :styles => {}, :processors => []
  validates_attachment_presence :attachment

end
