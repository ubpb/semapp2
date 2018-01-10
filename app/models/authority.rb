class Authority < ApplicationRecord

  ADMIN_ROLE     = 'ROLE_ADMIN'
  ASSISTANT_ROLE = 'ROLE_ASSISTANT'
  LECTURER_ROLE  = 'ROLE_LECTURER'

  validates_presence_of   :name
  validates_uniqueness_of :name
  validates_format_of     :name, :with => /\A[A-Z0-9_]+\z/
  validates_length_of     :name, :within => 3..20

  def name=(value)
    write_attribute :name, (value ? value.upcase : nil)
  end

end
