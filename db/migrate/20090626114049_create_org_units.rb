class CreateOrgUnits < ActiveRecord::Migration
  def self.up
    create_table :org_units do |t|
      t.string :title, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :org_units
  end
end
