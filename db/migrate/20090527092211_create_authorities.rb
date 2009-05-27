class CreateAuthorities < ActiveRecord::Migration
  def self.up
    create_table :authorities do |t|
      t.string :name, :null => false
      t.timestamps
    end

    add_index :authorities, :name, :unique => true
  end

  def self.down
    drop_table :authorities
  end
end
