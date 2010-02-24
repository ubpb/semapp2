class CreateMilessPasswords < ActiveRecord::Migration
  def self.up
    create_table :miless_passwords do |t|
      t.belongs_to :sem_app, :null => false
      t.string :password, :null => false
      t.timestamps
    end

    add_index :miless_passwords, :sem_app_id
    add_index :miless_passwords, :password
  end

  def self.down
    drop_table :miless_passwords
  end
end
