# encoding: utf-8

class BookShelf < ActiveRecord::Base

  # Relations
  belongs_to :sem_app

  # Validations
  validates_presence_of   :ils_account
  validates_presence_of   :slot_number
  validates_uniqueness_of :sem_app_id, :allow_nil => true, :allow_blank => false
  validates_uniqueness_of :ils_account

end
