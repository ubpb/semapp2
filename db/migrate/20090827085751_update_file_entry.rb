class UpdateFileEntry < ActiveRecord::Migration
  def self.up
    add_column :sem_app_file_entries, :attachment_file_name,    :string
    add_column :sem_app_file_entries, :attachment_content_type, :string
    add_column :sem_app_file_entries, :attachment_file_size,    :integer
    add_column :sem_app_file_entries, :attachment_updated_at,   :datetime
  end

  def self.down
    remove_column :sem_app_file_entries, :attachment_file_name
    remove_column :sem_app_file_entries, :attachment_content_type
    remove_column :sem_app_file_entries, :attachment_file_size
    remove_column :sem_app_file_entries, :attachment_updated_at
  end
end

