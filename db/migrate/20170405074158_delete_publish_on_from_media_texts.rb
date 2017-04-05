class DeletePublishOnFromMediaTexts < ActiveRecord::Migration
  def change
    remove_column :media_texts, :publish_on
  end
end
