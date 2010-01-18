# == Schema Information
# Schema version: 20091110135349
#
# Table name: authorities
#
#  id         :integer         not null, primary key
#  name       :string(255)     not null
#  created_at :datetime
#  updated_at :datetime
#

class Authority < ActiveRecord::Base

  ADMIN_ROLE    = 'ROLE_ADMIN'
  LECTURER_ROLE = 'ROLE_LECTURER'

  validates_presence_of   :name
  validates_uniqueness_of :name
  validates_format_of     :name, :with => /^[A-Z0-9_]+$/
  validates_length_of     :name, :within => 3..20

  def name=(value)
    write_attribute :name, (value ? value.upcase : nil)
  end

end
