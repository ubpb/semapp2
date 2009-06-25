class CreateSemesters < ActiveRecord::Migration
  def self.up
    create_table :semesters do |t|
      t.boolean :current, :null => true, :default => nil
      t.string :title, :null => false
      t.timestamps
    end

    add_index(:semesters, :current, :unique => true)
  end

  def self.down
    drop_table :semesters
  end
end
