# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2024_09_04_140728) do
  create_table "application_settings", id: :integer, charset: "utf8mb3", collation: "utf8mb3_general_ci", force: :cascade do |t|
    t.integer "transit_source_semester_id"
    t.integer "transit_target_semester_id"
    t.boolean "restrict_download_of_files_restricted_by_copyright", default: false, null: false
    t.index ["transit_source_semester_id"], name: "index_application_settings_on_transit_source_semester_id"
    t.index ["transit_target_semester_id"], name: "index_application_settings_on_transit_target_semester_id"
  end

  create_table "book_shelf_refs", id: :integer, charset: "utf8mb3", collation: "utf8mb3_general_ci", force: :cascade do |t|
    t.integer "sem_app_id", null: false
    t.integer "sem_app_ref_id", null: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["sem_app_id"], name: "book_shelf_refs_sem_app_id_fkey"
    t.index ["sem_app_ref_id"], name: "book_shelf_refs_sem_app_ref_id_fkey"
  end

  create_table "book_shelves", id: :integer, charset: "utf8mb3", collation: "utf8mb3_general_ci", force: :cascade do |t|
    t.string "ils_account", null: false
    t.string "slot_number", null: false
    t.integer "sem_app_id", null: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "semester_id"
    t.index ["sem_app_id"], name: "book_shelves_sem_app_id_fkey"
  end

  create_table "books", id: :integer, charset: "utf8mb3", collation: "utf8mb3_general_ci", force: :cascade do |t|
    t.integer "sem_app_id", null: false
    t.integer "creator_id"
    t.integer "placeholder_id"
    t.string "ils_id"
    t.string "signature"
    t.string "title"
    t.string "author"
    t.string "edition"
    t.string "place"
    t.string "publisher"
    t.string "year"
    t.string "isbn"
    t.text "comment"
    t.string "state", null: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "reference_copy"
    t.string "ebook_reference"
    t.index ["creator_id"], name: "books_creator_id_fkey"
    t.index ["ils_id"], name: "index_books_on_ils_id"
    t.index ["placeholder_id"], name: "books_placeholder_id_fkey"
    t.index ["sem_app_id", "ils_id"], name: "index_books_on_sem_app_id_and_ils_id", unique: true
    t.index ["state"], name: "index_books_on_state"
  end

  create_table "file_attachments", id: :integer, charset: "utf8mb3", collation: "utf8mb3_general_ci", force: :cascade do |t|
    t.integer "creator_id"
    t.string "file_file_name", null: false
    t.string "file_content_type", null: false
    t.integer "file_file_size", null: false
    t.text "description"
    t.boolean "scanjob", default: false, null: false
    t.datetime "updated_at", precision: nil
    t.integer "media_id"
    t.boolean "restricted_by_copyright", default: true, null: false
    t.index ["creator_id"], name: "file_attachments_creator_id_fkey"
  end

  create_table "locations", id: :integer, charset: "utf8mb3", collation: "utf8mb3_general_ci", force: :cascade do |t|
    t.string "title", null: false
    t.integer "position", default: 0, null: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "media", id: :integer, charset: "utf8mb3", collation: "utf8mb3_general_ci", force: :cascade do |t|
    t.integer "instance_id"
    t.string "instance_type"
    t.integer "sem_app_id"
    t.integer "creator_id"
    t.integer "position"
    t.string "miless_entry_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.boolean "hidden", default: false
    t.datetime "hidden_until", precision: nil
    t.index ["instance_id", "instance_type"], name: "index_media_on_instance_id_and_instance_type"
    t.index ["sem_app_id"], name: "index_media_on_sem_app_id"
  end

  create_table "media_articles", id: :integer, charset: "utf8mb3", collation: "utf8mb3_general_ci", force: :cascade do |t|
    t.text "author"
    t.text "title"
    t.text "subtitle"
    t.text "journal"
    t.text "place"
    t.text "publisher"
    t.text "volume"
    t.text "year"
    t.text "issue"
    t.text "pages_from"
    t.text "pages_to"
    t.text "issn"
    t.text "signature"
    t.text "comment"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "media_collected_articles", id: :integer, charset: "utf8mb3", collation: "utf8mb3_general_ci", force: :cascade do |t|
    t.text "source_editor"
    t.text "source_title"
    t.text "source_subtitle"
    t.text "source_year"
    t.text "source_place"
    t.text "source_publisher"
    t.text "source_edition"
    t.text "source_series_title"
    t.text "source_series_volume"
    t.text "source_signature"
    t.text "source_isbn"
    t.text "author"
    t.text "title"
    t.text "subtitle"
    t.text "volume"
    t.text "pages_from"
    t.text "pages_to"
    t.text "comment"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "media_headlines", id: :integer, charset: "utf8mb3", collation: "utf8mb3_general_ci", force: :cascade do |t|
    t.text "headline"
    t.integer "style", default: 0
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "media_monographs", id: :integer, charset: "utf8mb3", collation: "utf8mb3_general_ci", force: :cascade do |t|
    t.text "author"
    t.text "title"
    t.text "subtitle"
    t.text "year"
    t.text "place"
    t.text "publisher"
    t.text "edition"
    t.text "isbn"
    t.text "signature"
    t.text "comment"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "media_texts", id: :integer, charset: "utf8mb3", collation: "utf8mb3_general_ci", force: :cascade do |t|
    t.text "text"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "miless_passwords", id: :integer, charset: "utf8mb3", collation: "utf8mb3_general_ci", force: :cascade do |t|
    t.integer "sem_app_id", null: false
    t.string "password", null: false
    t.index ["password"], name: "index_miless_passwords_on_password"
    t.index ["sem_app_id"], name: "miless_passwords_sem_app_id_fkey"
  end

  create_table "ownerships", id: :integer, charset: "utf8mb3", collation: "utf8mb3_general_ci", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "sem_app_id", null: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["sem_app_id"], name: "index_ownerships_on_sem_app_id"
    t.index ["user_id"], name: "index_ownerships_on_user_id"
  end

  create_table "scanjobs", id: :integer, charset: "utf8mb3", collation: "utf8mb3_general_ci", force: :cascade do |t|
    t.integer "creator_id"
    t.string "state"
    t.text "message"
    t.integer "pages_from"
    t.integer "pages_to"
    t.string "signature"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.text "comment"
    t.integer "media_id"
    t.index ["creator_id"], name: "scanjobs_creator_id_fkey"
  end

  create_table "sem_apps", id: :integer, charset: "utf8mb3", collation: "utf8mb3_general_ci", force: :cascade do |t|
    t.integer "creator_id", null: false
    t.integer "semester_id", null: false
    t.integer "location_id", null: false
    t.boolean "approved", default: false
    t.string "title", limit: 1024, null: false
    t.text "tutors"
    t.string "shared_secret"
    t.string "course_id"
    t.string "miless_document_id"
    t.string "miless_derivate_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "access_token"
    t.index ["creator_id"], name: "sem_apps_creator_id_fkey"
    t.index ["location_id"], name: "sem_apps_location_id_fkey"
    t.index ["miless_derivate_id"], name: "index_sem_apps_on_miless_derivate_id"
    t.index ["miless_document_id"], name: "index_sem_apps_on_miless_document_id"
    t.index ["semester_id"], name: "sem_apps_semester_id_fkey"
  end

  create_table "semesters", id: :integer, charset: "utf8mb3", collation: "utf8mb3_general_ci", force: :cascade do |t|
    t.boolean "current"
    t.string "title", null: false
    t.integer "position", default: 0, null: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["current"], name: "index_semesters_on_current", unique: true
  end

  create_table "users", id: :integer, charset: "utf8mb3", collation: "utf8mb3_general_ci", force: :cascade do |t|
    t.string "login", null: false
    t.string "name"
    t.string "email"
    t.boolean "is_admin", default: false, null: false
    t.string "ilsuserid"
    t.index ["email"], name: "index_users_on_email"
    t.index ["ilsuserid"], name: "index_users_on_ilsuserid", unique: true
    t.index ["login"], name: "index_users_on_login", unique: true
  end

  add_foreign_key "book_shelf_refs", "sem_apps", column: "sem_app_ref_id", name: "book_shelf_refs_sem_app_ref_id_fkey"
  add_foreign_key "book_shelf_refs", "sem_apps", name: "book_shelf_refs_sem_app_id_fkey"
  add_foreign_key "book_shelves", "sem_apps", name: "book_shelves_sem_app_id_fkey"
  add_foreign_key "books", "sem_apps", column: "placeholder_id", name: "books_placeholder_id_fkey", on_delete: :nullify
  add_foreign_key "books", "sem_apps", name: "books_sem_app_id_fkey"
  add_foreign_key "books", "users", column: "creator_id", name: "books_creator_id_fkey"
  add_foreign_key "file_attachments", "users", column: "creator_id", name: "file_attachments_creator_id_fkey"
  add_foreign_key "miless_passwords", "sem_apps", name: "miless_passwords_sem_app_id_fkey"
  add_foreign_key "ownerships", "sem_apps", name: "ownerships_sem_app_id_fkey"
  add_foreign_key "ownerships", "users", name: "ownerships_user_id_fkey"
  add_foreign_key "scanjobs", "users", column: "creator_id", name: "scanjobs_creator_id_fkey"
  add_foreign_key "sem_apps", "locations", name: "sem_apps_location_id_fkey"
  add_foreign_key "sem_apps", "semesters", name: "sem_apps_semester_id_fkey"
  add_foreign_key "sem_apps", "users", column: "creator_id", name: "sem_apps_creator_id_fkey"
end
