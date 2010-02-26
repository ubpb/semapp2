class CreateBookPlaceholder < ActiveRecord::Migration
  def self.up
    add_column :books, :placeholder_id, :integer, :null => true
    
    add_index :books, :placeholder_id
  end

  def self.down
    remove_column :books, :placeholder_id
  end
end
