class RemoveAuthorities < ActiveRecord::Migration
  def up
    drop_table :authorities_users if table_exists? :authorities_users
    drop_table :authorities       if table_exists? :authorities
  end

  def down
  end
end
