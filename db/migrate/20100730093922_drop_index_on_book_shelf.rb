class DropIndexOnBookShelf < ActiveRecord::Migration
  def self.up
    execute('DROP INDEX index_book_shelves_on_sem_app_id;')
    execute('DROP INDEX index_book_shelves_on_ils_account;')
  end

  def self.down
  end
end
