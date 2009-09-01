class Book < ActiveRecord::Base

  belongs_to :sem_app

  validates_presence_of :sem_app
  validates_presence_of :signature
  validates_presence_of :title
  validates_presence_of :author
  validates_presence_of :year
  validates_presence_of :edition

  def base_signature
    Book.get_base_signature(signature)
  end

  def scheduled_for_addition=(value)
    write_attribute :scheduled_for_addition, value
    write_attribute :scheduled_for_removal, !value if (value == true)
  end

  def scheduled_for_removal=(value)
    write_attribute :scheduled_for_removal, value
    write_attribute :scheduled_for_addition, !value if (value == true)
  end

  def self.get_base_signature(signature)
    if signature.present?
      m = signature.match(/(.+)(\(|\+|-).*/)
      (m and m[1]) ? m[1] : signature
    end
  end

end
