class CreateSemesters < ActiveRecord::Migration
  def self.up
    create_table :semesters do |t|
      t.string :title, :null => false
      t.string :permalink, :null => false
      t.timestamps
    end

    add_index(:semesters, :permalink, :unique => true)
  end

  def self.down
    drop_table :semesters
  end
end
