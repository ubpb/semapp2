class Ownership < ApplicationRecord

  belongs_to :user
  belongs_to :sem_app

  validates_presence_of :user
  validates_presence_of :sem_app

end
