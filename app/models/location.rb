# encoding: utf-8

class Location < ActiveRecord::Base

  validates_presence_of :title

  acts_as_list

  def used?
    count > 0
  end

  def count
    SemApp.count(:conditions => "location_id = #{self.id}")
  end

end
