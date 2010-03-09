# encoding: utf-8

class MilessPassword < ActiveRecord::Base

  # Relations
  belongs_to :sem_app

  # Validations
  validates_presence_of :sem_app
  validates_presence_of :password

end
