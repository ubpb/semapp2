# == Schema Information
# Schema version: 20090110160902
#
# Table name: semesters
#
#  id         :integer(4)      not null, primary key
#  title      :string(255)     not null
#  permalink  :string(255)     not null
#  created_at :datetime
#  updated_at :datetime
#

class Semester < ActiveRecord::Base
  # model relations
  has_many :sem_apps, :dependent => :destroy

  # validators
  validates_presence_of :title
  validates_presence_of :permalink
  validates_uniqueness_of :permalink

  def to_s()
    title
  end

end
