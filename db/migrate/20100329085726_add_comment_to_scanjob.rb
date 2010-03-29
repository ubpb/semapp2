class AddCommentToScanjob < ActiveRecord::Migration
  def self.up
    add_column :scanjobs, :comment, :text, :null => true
  end

  def self.down
  end
end
