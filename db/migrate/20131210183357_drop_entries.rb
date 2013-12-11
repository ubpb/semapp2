class DropEntries < ActiveRecord::Migration
  def up
    drop_table :text_entries
    drop_table :article_entries
    drop_table :collected_article_entries
    drop_table :monograph_entries
    drop_table :miless_file_entries
    drop_table :headline_entries
    drop_table :entries
    remove_column :file_attachments, :entry_id
    remove_column :scanjobs,         :entry_id
  end
end
