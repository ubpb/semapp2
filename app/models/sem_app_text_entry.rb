# == Schema Information
# Schema version: 20090831113245
#
# Table name: sem_app_text_entries
#
#  id        :integer(4)      not null, primary key
#  body_text :text            default(""), not null
#

class SemAppTextEntry < ActiveRecord::Base

  has_one :sem_app_entry, :as => :instance, :dependent => :destroy

  validates_presence_of :body_text

end
