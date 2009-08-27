class CreateSemAppFileEntries < ActiveRecord::Migration
  def self.up
    create_table :sem_app_file_entries do |t|
      t.string :attachment_file_name, :null => false
      t.string :attachment_content_type, :null => false
      t.integer :attachment_file_size,    :null => false
      t.datetime :attachment_updated_at, :null => true
      t.text :comment
      t.timestamps
    end
  end

  def self.down
    drop_table :sem_app_file_entries
  end
end
