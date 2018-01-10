class Location < ApplicationRecord

  validates_presence_of :title

  acts_as_list

  def used?
    count > 0
  end

  def count
    SemApp.where("location_id = #{self.id}").count
  end

end
