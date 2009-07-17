class BookOrder < ActiveRecord::Base

  belongs_to :sem_app

  validates_presence_of :sem_app
  validates_presence_of :book_signature
  validates_presence_of :book_title

end