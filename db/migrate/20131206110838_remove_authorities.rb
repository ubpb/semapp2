begin
  require 'authority'
rescue LoadError
end

class RemoveAuthorities < ActiveRecord::Migration
  def up
    drop_table :authorities_users
    drop_table :authorities
  end

  def down
    if defined?(Authority)
      create_table :authorities do |t|
        t.string :name
        t.timestamps
      end

      Authority.create!(name: Authority::ADMIN_ROLE)

      create_table :authorities_users do |t|
        t.references :user
        t.references :authority
        t.timestamps
      end

      add_index :authorities_users, :user_id
      add_index :authorities_users, :authority_id
    end
  end
end
