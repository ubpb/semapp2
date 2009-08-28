class CreateSemAppEntries < ActiveRecord::Migration
  def self.up
    create_table :sem_app_entries do |t|
      t.references :sem_app, :null => false
      t.references :instance, :polymorphic => true, :null => false
      t.integer :position, :null => false, :default => 0;
      t.timestamps
    end
  end

  def self.down
    drop_table :sem_app_entries
  end
end
