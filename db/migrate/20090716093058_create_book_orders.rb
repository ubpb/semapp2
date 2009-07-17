class CreateBookOrders < ActiveRecord::Migration
  def self.up
    create_table :book_orders do |t|
      t.references :sem_app,        :null => false
      t.string     :book_signature, :null => false
      t.string     :book_title,     :null => false
      t.string     :book_author,    :null => true
      t.string     :book_year,      :null => true
      t.text       :message,        :null => true
      t.text       :status_message, :null => true
      t.timestamps
    end
  end

  def self.down
    drop_table :book_orders
  end
end
