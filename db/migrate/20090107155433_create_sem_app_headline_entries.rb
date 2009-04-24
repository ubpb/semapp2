class CreateSemAppHeadlineEntries < ActiveRecord::Migration
  def self.up
    create_table :sem_app_headline_entries do |t|
      t.string :headline, :null => false
    end
  end

  def self.down
    drop_table :sem_app_headline_entries
  end
end
