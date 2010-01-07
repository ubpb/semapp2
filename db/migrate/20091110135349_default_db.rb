class DefaultDb < ActiveRecord::Migration
  def self.up
    execute(File.read(File.join(RAILS_ROOT, "db", "migrate", "20091110135349_default_db.sql")))
  end

  def self.down
  end
end
