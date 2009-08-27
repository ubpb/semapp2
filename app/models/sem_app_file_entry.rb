# == Schema Information
# Schema version: 20090710121016
#
# Table name: sem_app_file_entries
#
#  id                      :integer(4)      not null, primary key
#  attachment_file_name    :string(255)     not null
#  attachment_content_type :string(255)     not null
#  attachment_file_size    :integer(4)      not null
#  attachment_updated_at   :datetime
#  comment                 :text
#  created_at              :datetime
#  updated_at              :datetime
#

class SemAppFileEntry < ActiveRecord::Base

  has_one :sem_app_entry, :as => :instance, :dependent => :destroy

  has_attached_file :attachment, :styles => {}, :processors => []
  validates_attachment_presence :attachment

end
