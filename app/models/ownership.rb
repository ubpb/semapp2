# == Schema Information
# Schema version: 20090710121016
#
# Table name: ownerships
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)      not null
#  sem_app_id :integer(4)      not null
#  created_at :datetime
#  updated_at :datetime
#

class Ownership < ActiveRecord::Base

  belongs_to :user
  belongs_to :sem_app

  validates_presence_of :user
  validates_presence_of :sem_app

end
