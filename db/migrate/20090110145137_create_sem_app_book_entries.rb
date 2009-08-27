class CreateSemAppBookEntries < ActiveRecord::Migration
  def self.up
    create_table :sem_app_book_entries do |t|
      t.string  :signature,              :null => false
      t.string  :title,                  :null => false
      t.string  :author,                 :null => false
      t.string  :edition,                :null => true
      t.string  :place,                  :null => true
      t.string  :publisher,              :null => true
      t.string  :year,                   :null => true
      t.string  :isbn,                   :null => true
      t.text    :comment,                :null => true
      t.boolean :scheduled_for_addition, :null => false, :default => false
      t.boolean :scheduled_for_removal,  :null => false, :default => false
      t.text    :order_status,           :null => true
      t.timestamps
    end

    add_index :sem_app_book_entries, :signature
    add_index :sem_app_book_entries, :scheduled_for_addition
    add_index :sem_app_book_entries, :scheduled_for_removal
  end

  def self.down
    drop_table :sem_app_book_entries
  end
end
