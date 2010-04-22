class UpdatedAtForAttachments < ActiveRecord::Migration
  def self.up
    add_column :file_attachments, :updated_at, :timestamp
  end

  def self.down
    remove_column :file_attachments, :updated_at
  end
end
