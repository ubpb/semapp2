class BookShelf < ActiveRecord::Base

  # Relations
  belongs_to :sem_app
  belongs_to :semester

  # Validations
  validates_presence_of   :ils_account
  validates_presence_of   :slot_number
  validates_presence_of   :sem_app_id
  validates_uniqueness_of :ils_account, scope: :semester_id

  before_validation :set_semester

  ###########################################################################################
  #
  # Public API
  #
  ###########################################################################################

  def ils_account=(value)
    write_attribute :ils_account, value.present? ? clean_ils_account!(value) : nil
  end

  ##
  # TODO: This is a test, to return a clean ils account (9 digits)
  # number without the check digit.
  def clean_ils_account
    clean_ils_account!(self.ils_account)
  end

protected

  def set_semester
    self.semester = sem_app.semester if sem_app.semester
  end

  def clean_ils_account!(ils_account)
    ils_account.gsub(/\s+/, '').slice(0..8)
  end

end
