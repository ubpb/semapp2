class DefaultDb < ActiveRecord::Migration
  def self.up

    ############################################################################
    #
    # Users
    #
    ############################################################################

    create_table :users do |t|
      t.string    :authid,              :null => false
      t.boolean   :active,              :null => false, :default => false
      t.boolean   :approved,            :bull => false, :default => false

      # Profile and Authlogic stuff
      t.string    :firstname,           :null => false
      t.string    :lastname,            :null => false
      t.string    :login,               :null => false
      t.string    :email,               :null => false
      t.string    :phone,               :null => true
      t.string    :department,          :null => true
      t.string    :crypted_password,    :null => false
      t.string    :password_salt,       :null => false
      t.string    :persistence_token,   :null => false
      t.string    :single_access_token, :null => false
      t.string    :perishable_token,    :null => false

      # Authlogic magic columns, just like ActiveRecord's created_at and updated_at.
      # These are automatically maintained by Authlogic if they are present.
      t.integer   :login_count,         :null => false, :default => 0
      t.integer   :failed_login_count,  :null => false, :default => 0
      t.datetime  :last_request_at
      t.datetime  :current_login_at
      t.datetime  :last_login_at
      t.string    :current_login_ip
      t.string    :last_login_ip
    end

    add_index :users, [:authid, :login], :unique => true
    add_index :users, :login
    add_index :users, :email

    ############################################################################
    #
    # Sessions (Session Store)
    #
    ############################################################################

    create_table :sessions do |t|
      t.string :session_id, :null => false
      t.text   :data,       :null => true
      t.timestamps
    end

    add_index :sessions, :session_id
    add_index :sessions, :updated_at

    ############################################################################
    #
    # Authorities
    #
    ############################################################################

    create_table :authorities do |t|
      t.string :name, :null => false
      t.timestamps
    end

    add_index :authorities, :name, :unique => true

    ############################################################################
    #
    # Authorities <> Users
    #
    ############################################################################

    create_table :authorities_users, :id => false do |t|
      t.belongs_to :authority, :null => false
      t.belongs_to :user,      :null => false
    end

    add_index :authorities_users, [:authority_id, :user_id], :unique => true

    add_foreign_key :authorities_users, :authority_id, :authorities, :id
    add_foreign_key :authorities_users, :user_id,      :users,       :id

    ############################################################################
    #
    # Semesters
    #
    ############################################################################

    create_table :semesters do |t|
      t.boolean :current,  :null => true, :default => nil
      t.string  :title,    :null => false
      t.integer :position, :null => false, :default => 0
      t.timestamps
    end

    add_index :semesters, :current, :unique => true

    ############################################################################
    #
    # Locations
    #
    ############################################################################

    create_table :locations do |t|
      t.string  :title,    :null => false
      t.integer :position, :null => false, :default => 0
      t.timestamps
    end

    ############################################################################
    #
    # SemApp
    #
    ############################################################################

    create_table :sem_apps do |t|
      t.belongs_to :creator,        :null => false
      t.belongs_to :semester,       :null => false
      t.belongs_to :location,       :null => false
      t.boolean    :approved,       :null => false, :default => false
      t.string     :title,          :null => false
      t.text       :tutors,         :null => false
      t.string     :shared_secret,  :null => false
      t.string     :course_id,      :null => true
      t.timestamps
    end

    add_index :sem_apps, [:title,     :semester_id], :unique => true
    add_index :sem_apps, [:course_id, :semester_id], :unique => true

    add_foreign_key :sem_apps, :creator_id,  :users,     :id
    add_foreign_key :sem_apps, :semester_id, :semesters, :id
    add_foreign_key :sem_apps, :location_id, :locations, :id

    ############################################################################
    #
    # Book Shelf
    #
    ############################################################################

    create_table :book_shelves do |t|
      t.string     :ils_account, :null => false
      t.string     :slot_number, :null => false
      t.belongs_to :sem_app,     :null => true
      t.timestamps
    end

    add_index :book_shelves, :sem_app_id,  :unique => true
    add_index :book_shelves, :ils_account, :unique => true

    add_foreign_key :book_shelves, :sem_app_id, :sem_apps, :id

    ############################################################################
    #
    # SemApp ownerships
    #
    ############################################################################

    create_table :ownerships do |t|
      t.belongs_to :user, :null => false
      t.belongs_to :sem_app, :null => false
      t.timestamps
    end

    add_index :ownerships, [:user_id, :sem_app_id]

    add_foreign_key :ownerships, :user_id,    :users,    :id
    add_foreign_key :ownerships, :sem_app_id, :sem_apps, :id

    ############################################################################
    #
    # SemApp entries
    #
    ############################################################################

    create_table :sem_app_entries do |t|
      t.belongs_to :sem_app,  :null => false
      t.belongs_to :instance, :null => false, :polymorphic => true
      t.integer    :position, :null => false, :default => 0
      t.timestamps
    end

    add_foreign_key :sem_app_entries, :sem_app_id, :sem_apps, :id

    create_table :sem_app_text_entries do |t|
      t.text :body_text, :null => false
    end

    create_table :sem_app_headline_entries do |t|
      t.string :headline, :null => false
    end

    create_table :sem_app_file_entries do |t|
      t.string   :attachment_file_name,    :null => false
      t.string   :attachment_content_type, :null => false
      t.integer  :attachment_file_size,    :null => false
      t.string   :title,                   :null => false
      t.text     :description,             :null => true
      t.timestamps
    end

    ############################################################################
    #
    # Books
    #
    ############################################################################

    create_table :books do |t|
      t.belongs_to :sem_app,                :null => false
      t.string     :signature,              :null => false
      t.string     :title,                  :null => false
      t.string     :author,                 :null => false
      t.string     :edition,                :null => true
      t.string     :place,                  :null => true
      t.string     :publisher,              :null => true
      t.string     :year,                   :null => true
      t.string     :isbn,                   :null => true
      t.text       :comment,                :null => true
      t.boolean    :scheduled_for_addition, :null => false, :default => false
      t.boolean    :scheduled_for_removal,  :null => false, :default => false
      t.timestamps
    end

    add_index :books, :signature
    add_index :books, :scheduled_for_addition
    add_index :books, :scheduled_for_removal

    add_foreign_key :books, :sem_app_id, :sem_apps, :id

  end

  def self.down
    drop_table :books
    drop_table :sem_app_file_entries
    drop_table :sem_app_headline_entries
    drop_table :sem_app_text_entries
    drop_table :sem_app_entries
    drop_table :ownerships
    drop_table :sem_apps
    drop_table :locations
    drop_table :semesters
    drop_table :authorities_users
    drop_table :authorities
    drop_table :sessions
    drop_table :users
  end
end
