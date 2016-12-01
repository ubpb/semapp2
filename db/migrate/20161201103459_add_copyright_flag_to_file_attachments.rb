class AddCopyrightFlagToFileAttachments < ActiveRecord::Migration
  def change

    add_column :file_attachments, :restricted_by_copyright, :boolean, null: false, default: true

  end
end
