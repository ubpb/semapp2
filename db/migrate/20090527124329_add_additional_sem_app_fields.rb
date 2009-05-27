class AddAdditionalSemAppFields < ActiveRecord::Migration
  def self.up
    add_column :sem_apps, :active, :boolean, :null => false, :default => false
  end

  def self.down
    remove_column :sem_apps, :active
  end
end
