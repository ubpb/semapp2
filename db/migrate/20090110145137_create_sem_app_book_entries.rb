class CreateSemAppBookEntries < ActiveRecord::Migration
  def self.up
    create_table :sem_app_book_entries do |t|
      #t.string :bid,       :null => false
      t.string :signature, :null => false
      t.string :title,     :null => false
      t.string :author,    :null => false
      t.string :edition
      t.string :place
      t.string :publisher
      t.string :year
      t.string :isbn
      t.text   :comment
      t.timestamps
    end

    #add_index :sem_app_book_entries, :bid
    add_index :sem_app_book_entries, :signature
  end

  def self.down
    #remove_index :sem_app_book_entries, :bid
    #remove_index :sem_app_book_entries, :signature

    drop_table :sem_app_book_entries
  end
end
