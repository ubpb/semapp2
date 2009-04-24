class CreateSemAppTextEntries < ActiveRecord::Migration
  def self.up
    create_table :sem_app_text_entries do |t|
      t.text :body_text, :null => false
    end
  end

  def self.down
    drop_table :sem_app_text_entries
  end
end
