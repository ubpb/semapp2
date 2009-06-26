# == Schema Information
# Schema version: 20090110160902
#
# Table name: sem_apps
#
#  id              :integer(4)      not null, primary key
#  semester_id     :integer(4)      not null
#  title           :string(255)
#  permalink       :string(255)
#  bid             :string(255)
#  books_synced_at :datetime
#  created_at      :datetime
#  updated_at      :datetime
#

class SemApp < ActiveRecord::Base

  belongs_to :semester
  belongs_to :org_unit

  has_many :ownerships
  has_many :owners, :through => :ownerships, :source => :user

  validates_presence_of   :semester
  validates_presence_of   :org_unit
  validates_presence_of   :title
  validates_uniqueness_of :title, :scope => :semester_id

  def book_entries
    # sync books
    sync_books
    # return book entries
    do_get_book_entries
  end

  def media_entries
    # return media entries
    do_get_media_entries
  end

  def add_ownership(user)
    Ownership.new(:user => user, :sem_app => self).save!
  end

  private

  def do_get_book_entries
    SemAppEntry.find(
      :all,
      :include => [:instance],
      :conditions => ["sem_app_id = :sem_app_id AND instance_type = :instance_type",
        {:sem_app_id => id, :instance_type => 'SemAppBookEntry'}],
      :order => :position)
  end

  def do_get_media_entries
    SemAppEntry.find(
      :all,
      :include => [:instance],
      :conditions => ["sem_app_id = :sem_app_id AND instance_type <> :instance_type",
        {:sem_app_id => id, :instance_type => 'SemAppBookEntry'}],
      :order => :position)
  end

  def sync_books
    if (self.bid and self.bid.present? and (!self.books_synced_at or Time.now - self.books_synced_at > 30.minutes))
      SemApp.transaction do
        aleph_books = Aleph::BookImporter.import_books(self.bid)

        SemAppBookEntry.transaction do
          #
          # Add / Update book entries
          #
          aleph_books.each do |aleph_book|
            book = SemAppBookEntry.find_by_bid(aleph_book.bid)
            if book
              #
              # Update an existing book entry
              #
              book = book_entry_from_aleph_book(book, aleph_book)
              book.save!
            else
              #
              # Add a new book entry
              #
              b = SemAppBookEntry.new()
              b = book_entry_from_aleph_book(b, aleph_book)
              
              entry = SemAppEntry.new(:sem_app => self, :instance => b)
              entry.save!
            end
          end

          #
          # Remove books that are no longer in alpeh
          #

          # TODO: Remove books that are no longer in Aleph
        end

        self.books_synced_at = Time.now
        self.save!
      end
    end
  end

  def book_entry_from_aleph_book(book_entry, aleph_book)
    book_entry.bid       = aleph_book.bid
    book_entry.signature = aleph_book.signature
    book_entry.title     = aleph_book.title
    book_entry.author    = aleph_book.author
    book_entry.edition   = aleph_book.edition
    book_entry.place     = aleph_book.place
    book_entry.publisher = aleph_book.publisher
    book_entry.year      = aleph_book.year
    book_entry.isbn      = aleph_book.isbn
    return book_entry
  end

end
