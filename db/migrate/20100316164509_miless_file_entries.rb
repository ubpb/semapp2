class MilessFileEntries < ActiveRecord::Migration
  def self.up
    execute(File.read(File.join(::Rails.root.to_s, "db", "migrate", "20100316164509_miless_file_entries.sql")))
  end

  def self.down
    drop_table :miless_file_entries
  end
end
