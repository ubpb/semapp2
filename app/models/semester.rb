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

  def current=(value)
    write_attribute(:current, nil) if value == 0 or value == nil or value == "0" or value == false

    if (value == 1 or value == "1" or value == true)
      Semester.transaction do
        Semester.find(:all).each do |s|
          s.current = nil
          s.save!
        end
      end

      write_attribute(:current, true)
    end
  end

end
