# == Schema Information
# Schema version: 20091110135349
#
# Table name: locations
#
#  id         :integer(4)      not null, primary key
#  title      :string(255)     not null
#  position   :integer(4)      default(0), not null
#  created_at :datetime
#  updated_at :datetime
#

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
