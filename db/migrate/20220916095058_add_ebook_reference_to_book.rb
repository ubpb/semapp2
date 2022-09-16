class AddEbookReferenceToBook < ActiveRecord::Migration[6.0]
  def change
    add_column :books, :ebook_reference, :string, null: true
  end
end
