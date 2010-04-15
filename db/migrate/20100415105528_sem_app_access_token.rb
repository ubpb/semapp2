class SemAppAccessToken < ActiveRecord::Migration
  def self.up
    add_column :sem_apps, :access_token, :string, :null => true
  end

  def self.down
  end
end
