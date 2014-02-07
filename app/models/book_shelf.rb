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

  ##
  # FIXME: This is a test, to return a clean ils account (9 digits)
  # number without the check digit.
  def clean_ils_account
    ils_account[0..8]
  end

end
