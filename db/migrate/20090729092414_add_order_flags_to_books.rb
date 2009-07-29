class AddOrderFlagsToBooks < ActiveRecord::Migration
  def self.up
    add_column :sem_app_book_entries, :scheduled_for_addition, :boolean, :default => false
    add_column :sem_app_book_entries, :order_status, :text
  end

  def self.down
    remove_column :sem_app_book_entries, :scheduled_for_addition
    remove_column :sem_app_book_entries, :order_status
  end
end
