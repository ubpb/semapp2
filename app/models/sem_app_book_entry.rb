# == Schema Information
# Schema version: 20090110160902
#
# Table name: sem_app_book_entries
#
#  id         :integer(4)      not null, primary key
#  bid        :string(255)     not null
#  signature  :string(255)     not null
#  title      :string(255)     not null
#  author     :string(255)     not null
#  edition    :string(255)
#  place      :string(255)
#  publisher  :string(255)
#  year       :string(255)
#  isbn       :string(255)
#  comment    :text
#  created_at :datetime
#  updated_at :datetime
#

class SemAppBookEntry < ActiveRecord::Base

  has_one :sem_app_entry, :as => :instance, :dependent => :destroy

  validates_presence_of :bid
  validates_presence_of :signature
  validates_presence_of :title
  validates_presence_of :author

end
