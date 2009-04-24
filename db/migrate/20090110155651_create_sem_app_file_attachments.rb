class CreateSemAppFileAttachments < ActiveRecord::Migration
  def self.up
    create_table :sem_app_file_attachments do |t|
      t.references :attachable, :polymorphic => true, :null => false
      t.string :attachment_file_name, :null => false
      t.string :attachment_content_type, :null => false
      t.string :attachment_file_size, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :sem_app_file_attachments
  end
end
