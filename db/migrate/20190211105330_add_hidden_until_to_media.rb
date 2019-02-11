class AddHiddenUntilToMedia < ActiveRecord::Migration[5.1]
  def change
    add_column :media, :hidden_until, :datetime, null: true, index: true
  end
end
