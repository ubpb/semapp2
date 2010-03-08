class AddHeaderStyles < ActiveRecord::Migration
  def self.up
    add_column :headline_entries, :style, :integer, :default => 0
  end
end
