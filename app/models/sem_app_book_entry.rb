# == Schema Information
# Schema version: 20090729092414
#
# Table name: sem_app_book_entries
#
#  id                     :integer(4)      not null, primary key
#  bid                    :string(255)     not null
#  signature              :string(255)     not null
#  title                  :string(255)     not null
#  author                 :string(255)     not null
#  edition                :string(255)
#  place                  :string(255)
#  publisher              :string(255)
#  year                   :string(255)
#  isbn                   :string(255)
#  comment                :text
#  created_at             :datetime
#  updated_at             :datetime
#  scheduled_for_removal  :boolean(1)
#  scheduled_for_addition :boolean(1)
#  order_status           :text
#

class SemAppBookEntry < ActiveRecord::Base

  has_one :sem_app_entry, :as => :instance, :dependent => :destroy

  validates_presence_of :signature
  validates_presence_of :title
  validates_presence_of :author

  def scheduled_for_addition=(value)
    write_attribute :scheduled_for_addition, value
    write_attribute :scheduled_for_removal, !value
  end

  def scheduled_for_removal=(value)
    write_attribute :scheduled_for_removal, value
    write_attribute :scheduled_for_addition, !value
  end

end
