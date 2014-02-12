class RemoveArchivedFeature < ActiveRecord::Migration
  def up
    remove_column :sem_apps, :archived
  end
end
