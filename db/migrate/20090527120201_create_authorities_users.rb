class CreateAuthoritiesUsers < ActiveRecord::Migration
  def self.up
    create_table :authorities_users, :id => false do |t|
      t.references :authority, :null => false
      t.references :user, :null => false
    end

    add_index :authorities_users, [:authority_id, :user_id], :unique => true
  end

  def self.down
    drop_table :authorities_users
  end
end
