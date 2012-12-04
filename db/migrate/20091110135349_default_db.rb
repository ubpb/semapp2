class DefaultDb < ActiveRecord::Migration
  def self.up
    execute(File.read(File.join(::Rails.root.to_s, "db", "migrate", "20091110135349_default_db.sql")))
  end

  def self.down
  end
end
