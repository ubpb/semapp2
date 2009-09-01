# == Schema Information
# Schema version: 20090831113245
#
# Table name: sem_app_book_entries
#
#  id                     :integer(4)      not null, primary key
#  signature              :string(255)     not null
#  title                  :string(255)     not null
#  author                 :string(255)     not null
#  edition                :string(255)
#  place                  :string(255)
#  publisher              :string(255)
#  year                   :string(255)
#  isbn                   :string(255)
#  comment                :text
#  scheduled_for_addition :boolean(1)      not null
#  scheduled_for_removal  :boolean(1)      not null
#  order_status           :text
#  created_at             :datetime
#  updated_at             :datetime
#

class SemAppBookEntry < ActiveRecord::Base

  has_one :sem_app_entry, :as => :instance, :dependent => :destroy

  validates_presence_of :signature
  validates_presence_of :title
  validates_presence_of :author

  def base_signature
    SemAppBookEntry.get_base_signature(signature)
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
