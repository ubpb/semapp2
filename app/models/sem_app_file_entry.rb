# == Schema Information
# Schema version: 20090729092414
#
# Table name: sem_app_file_entries
#
#  id         :integer(4)      not null, primary key
#  comment    :text
#  created_at :datetime
#  updated_at :datetime
#

class SemAppFileEntry < ActiveRecord::Base

  has_one :sem_app_entry, :as => :instance, :dependent => :destroy

  #has_one :sem_app_file_attachment, :as => :attachable, :dependent => :destroy

  #validates_presence_of :sem_app_file_attachment

  has_attached_file :attachment, :styles => {}, :processors => []
  validates_attachment_presence :attachment

end
