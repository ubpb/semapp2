class OrgUnit < ActiveRecord::Base

  validates_presence_of :title

  def used?
    count > 0
  end

  def count
    SemApp.count(:conditions => "org_unit_id = #{self.id}")
  end

end