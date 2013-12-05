class ApplicationSettings < ActiveRecord::Migration
  def change
    create_table :application_settings do |t|
      t.belongs_to :transit_source_semester
      t.belongs_to :transit_target_semester
    end

    add_index :application_settings, :transit_source_semester_id
    add_index :application_settings, :transit_target_semester_id
  end
end
