class CreateSemAppWeblinkEntries < ActiveRecord::Migration
  def self.up
    create_table :sem_app_weblink_entries do |t|
      t.string :url, :null => false
      t.text :comment
      t.timestamps
    end
  end

  def self.down
    drop_table :sem_app_weblink_entries
  end
end
