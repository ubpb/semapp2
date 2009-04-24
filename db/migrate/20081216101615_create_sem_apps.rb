class CreateSemApps < ActiveRecord::Migration
  def self.up
    create_table :sem_apps do |t|
      t.references :semester, :null => false
      t.string   :title
      t.string   :permalink
      t.string   :bid
      t.datetime :books_synced_at
      t.timestamps
    end

    add_index :sem_apps, [:permalink, :semester_id], :unique => true
    add_index :sem_apps, :bid
  end

  def self.down
    remove_index :sem_apps, [:permalink, :semester_id]
    remove_index :sem_apps, :bid
    drop_table :sem_apps
  end
end
