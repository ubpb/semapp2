class AddReferenceCopyToBooks < ActiveRecord::Migration
  def self.up
    add_column :books, :reference_copy, :integer, :null => true
  end

  def self.down
  end
end
