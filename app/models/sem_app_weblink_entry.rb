# == Schema Information
# Schema version: 20090721145838
#
# Table name: sem_app_weblink_entries
#
#  id         :integer(4)      not null, primary key
#  url        :string(255)     not null
#  comment    :text
#  created_at :datetime
#  updated_at :datetime
#

class SemAppWeblinkEntry < ActiveRecord::Base

  has_one :sem_app_entry, :as => :instance, :dependent => :destroy

  validates_presence_of :url

end
