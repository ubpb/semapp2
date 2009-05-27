class Authority < ActiveRecord::Base

  validates_presence_of   :name
  validates_uniqueness_of :name
  validates_format_of     :name, :with => /^[A-Z0-9_]+$/
  validates_length_of     :name, :within => 3..20

  def name=(value)
    write_attribute :name, (value ? value.upcase : nil)
  end

end
