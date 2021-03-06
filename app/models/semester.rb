class Semester < ApplicationRecord
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
        ActiveRecord::Base.connection.execute('update semesters set current = NULL')
        write_attribute(:current, true)
      end
    end
  end

  def self.current
    Semester.where(current: true).first
  end

  def self.next
    Semester.current&.higher_item
  end

  def self.previous
    Semester.current&.lower_item
  end

  def self.transit_target
    Semester.next || Semester.current
  end

end
