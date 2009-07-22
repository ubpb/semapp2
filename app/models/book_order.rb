# == Schema Information
# Schema version: 20090721145838
#
# Table name: book_orders
#
#  id             :integer(4)      not null, primary key
#  sem_app_id     :integer(4)      not null
#  book_signature :string(255)     not null
#  book_title     :string(255)     not null
#  book_author    :string(255)
#  book_year      :string(255)
#  message        :text
#  status_message :text
#  created_at     :datetime
#  updated_at     :datetime
#

class BookOrder < ActiveRecord::Base

  belongs_to :sem_app

  validates_presence_of :sem_app
  validates_presence_of :book_signature
  validates_presence_of :book_title

end
