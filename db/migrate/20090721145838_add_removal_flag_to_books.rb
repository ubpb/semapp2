class AddDeletionFlagToBooks < ActiveRecord::Migration
  def self.up
    add_column :sem_app_book_entries, :scheduled_for_removal, :boolean, :default => false
  end

  def self.down
    remove_column :sem_app_book_entries, :scheduled_for_removal
  end
end
