class AddHiddenFlagToMedia < ActiveRecord::Migration
  def change
    add_column :media, :hidden, :boolean, default: false
  end
end
