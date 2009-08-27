# == Schema Information
# Schema version: 20090710121016
#
# Table name: sem_app_headline_entries
#
#  id       :integer(4)      not null, primary key
#  headline :string(255)     not null
#

class SemAppHeadlineEntry < ActiveRecord::Base

  has_one :sem_app_entry, :as => :instance, :dependent => :destroy

  validates_presence_of :headline

end
