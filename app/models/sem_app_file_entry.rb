# == Schema Information
# Schema version: 20090721145838
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

  has_one :sem_app_file_attachment, :as => :attachable, :dependent => :destroy

end
