class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      t.string  :title, :null => false
      t.integer :position
      t.timestamps
    end
  end

  def self.down
    drop_table :locations
  end
end
