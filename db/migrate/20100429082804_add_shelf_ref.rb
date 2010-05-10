class AddShelfRef < ActiveRecord::Migration
  def self.up
    execute """
    CREATE TABLE book_shelf_refs (
      id serial NOT NULL PRIMARY KEY,
      sem_app_id integer REFERENCES sem_apps NOT NULL,
      sem_app_ref_id integer REFERENCES sem_apps NOT NULL,
      created_at timestamp without time zone,
      updated_at timestamp without time zone
    );
    """
  end

  def self.down
    execute('DROP TABLE book_shelf_refs')
  end
end
