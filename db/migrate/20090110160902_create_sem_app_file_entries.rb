class CreateSemAppFileEntries < ActiveRecord::Migration
  def self.up
    create_table :sem_app_file_entries do |t|
      t.text :comment
      t.timestamps
    end
  end

  def self.down
    drop_table :sem_app_file_entries
  end
end
