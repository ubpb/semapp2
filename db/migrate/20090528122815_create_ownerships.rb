class CreateOwnerships < ActiveRecord::Migration
  def self.up
    create_table :ownerships do |t|
      t.references :user, :null => false
      t.references :sem_app, :null => false
      t.boolean    :can_write, :null => false, :default => false
      t.timestamps
    end

    add_index :ownerships, [:user_id, :sem_app_id], :unique => true
  end

  def self.down
    drop_table :ownerships
  end
end
