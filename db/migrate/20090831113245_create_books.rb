class CreateBooks < ActiveRecord::Migration
  def self.up
    create_table :books do |t|
      t.references :sem_app,                :null => false
      t.string     :signature,              :null => false
      t.string     :title,                  :null => false
      t.string     :author,                 :null => false
      t.string     :edition,                :null => true
      t.string     :place,                  :null => true
      t.string     :publisher,              :null => true
      t.string     :year,                   :null => true
      t.string     :isbn,                   :null => true
      t.text       :comment,                :null => true
      t.boolean    :scheduled_for_addition, :null => false, :default => false
      t.boolean    :scheduled_for_removal,  :null => false, :default => false
      t.timestamps
    end

    add_index :books, :signature
    add_index :books, :scheduled_for_addition
    add_index :books, :scheduled_for_removal
  end

  def self.down
    drop_table :books
  end
end
