# == Schema Information
# Schema version: 20091110135349
#
# Table name: ownerships
#
#  id         :integer         not null, primary key
#  user_id    :integer         not null
#  sem_app_id :integer         not null
#  created_at :datetime
#  updated_at :datetime
#

class Ownership < ActiveRecord::Base

  belongs_to :user
  belongs_to :sem_app

  validates_presence_of :user
  validates_presence_of :sem_app

end
