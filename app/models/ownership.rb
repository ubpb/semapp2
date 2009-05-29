class Ownership < ActiveRecord::Base

  belongs_to :user
  belongs_to :sem_app

  validates_presence_of :user
  validates_presence_of :sem_app
  #validates_uniqueness_of :user, :scope => :sem_app_id

end
