# == Schema Information
# Schema version: 20090729092414
#
# Table name: semesters
#
#  id         :integer(4)      not null, primary key
#  current    :boolean(1)
#  title      :string(255)     not null
#  position   :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class Semester < ActiveRecord::Base
  # model relations
  has_many :sem_apps, :dependent => :destroy

  # acts as ...
  acts_as_list

  # validators
  validates_presence_of :title

  def to_s()
    title
  end

  def current=(value)
    if value == 0 or value == nil or value == "0" or value == false
      write_attribute(:current, nil)
    else
      unless current
        connection.execute('update semesters set current = NULL')
        write_attribute(:current, true)
      end
    end
  end

  def self.current
    Semester.find(:first, :conditions => {:current => true})
  end

end
