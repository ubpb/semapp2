class Scanjob < ActiveRecord::Base

  # Realations
  belongs_to :entry

  # Validation
  validates_presence_of :entry
  validates_presence_of :pages

  #################################################################################
  #
  # Public API
  #
  #################################################################################

end