# encoding: utf-8

class BookShelf < ActiveRecord::Base

  # Relations
  belongs_to :sem_app

  # Validations
  validates_presence_of :ils_account
  validates_presence_of :slot_number
  validates_presence_of :sem_app_id

  ###########################################################################################
  #
  # Public API
  #
  ###########################################################################################

  def ils_account=(value)
    write_attribute :ils_account, value.present? ? value.gsub(/\s/, '') : nil
  end

end
