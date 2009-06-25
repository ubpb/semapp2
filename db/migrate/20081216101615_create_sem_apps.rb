class CreateSemApps < ActiveRecord::Migration
  def self.up
    create_table :sem_apps do |t|
      t.references :semester, :null => false
      t.boolean    :active,   :null => false, :default => false
      t.string     :title,    :null => false
      t.string     :bid
      t.datetime   :books_synced_at
      t.timestamps
    end

    add_index :sem_apps, [:title, :semester_id], :unique => true
    add_index :sem_apps, :bid
  end

  def self.down
    drop_table :sem_apps
  end
end
