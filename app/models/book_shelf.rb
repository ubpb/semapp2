# == Schema Information
# Schema version: 20091110135349
#
# Table name: book_shelves
#
#  id          :integer(4)      not null, primary key
#  ils_account :string(255)     not null
#  slot_number :string(255)     not null
#  sem_app_id  :integer(4)
#  created_at  :datetime
#  updated_at  :datetime
#

class BookShelf < ActiveRecord::Base

  # Relations
  belongs_to :sem_app

  # Validations
  validates_presence_of   :ils_account
  validates_presence_of   :slot_number
  validates_uniqueness_of :sem_app_id, :allow_nil => true, :allow_blank => false
  validates_uniqueness_of :ils_account

end
