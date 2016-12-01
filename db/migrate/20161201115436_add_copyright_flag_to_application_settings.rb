class AddCopyrightFlagToApplicationSettings < ActiveRecord::Migration
  def change

    add_column :application_settings, :restrict_download_of_files_restricted_by_copyright, :boolean, null: false, default: false

  end
end
