# == Schema Information
# Schema version: 20091110135349
#
# Table name: sem_app_entries
#
#  id         :integer         not null, primary key
#  sem_app_id :integer         not null
#  position   :integer
#  publish_on :datetime
#  created_at :datetime
#  updated_at :datetime
#

class SemAppEntry < ActiveRecord::Base

  belongs_to :sem_app
  acts_as_inheritance_root
  acts_as_list :scope => :sem_app

  validates_presence_of :sem_app

  def to_be_published
    self.publish_on.present? and self.publish_on >= Time.new
  end

end
