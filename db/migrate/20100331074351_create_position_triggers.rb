class CreatePositionTriggers < ActiveRecord::Migration
  def self.up
    execute(File.read(File.join(::Rails.root.to_s, "db", "migrate", "20100331074351_create_position_triggers.sql")))
  end

  def self.down
    execute(File.read(File.join(::Rails.root.to_s, "db", "migrate", "20100331074351_drop_position_triggers.sql")))
  end
end
