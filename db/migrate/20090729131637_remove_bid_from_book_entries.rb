class RemoveBidFromBookEntries < ActiveRecord::Migration
  def self.up
    remove_index  :sem_app_book_entries, :bid
    remove_column :sem_app_book_entries, :bid
  end

  def self.down
    add_column :sem_app_book_entries, :bid, :string, :null => false
    add_index :sem_app_book_entries, :bid
  end
end
