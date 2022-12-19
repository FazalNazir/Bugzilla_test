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

ActiveRecord::Schema[7.0].define(version: 2022_12_02_075718) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories_courses", id: false, force: :cascade do |t|
    t.bigint "category_id"
    t.bigint "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_categories_courses_on_category_id"
    t.index ["course_id"], name: "index_categories_courses_on_course_id"
  end

  create_table "courses", force: :cascade do |t|
    t.string "title"
    t.string "created_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "enrollments", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "course_id"
    t.datetime "start_date"
    t.datetime "due_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_enrollments_on_course_id"
    t.index ["user_id"], name: "index_enrollments_on_user_id"
  end

  create_table "evaluations", force: :cascade do |t|
    t.bigint "evaluator_id"
    t.bigint "enrollment_id"
    t.bigint "task_id"
    t.boolean "re_evaluation", default: false
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["enrollment_id"], name: "index_evaluations_on_enrollment_id"
    t.index ["evaluator_id"], name: "index_evaluations_on_evaluator_id"
    t.index ["task_id"], name: "index_evaluations_on_task_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "external_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string "title"
    t.string "location"
    t.string "description"
    t.string "eventable_type"
    t.bigint "eventable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["eventable_type", "eventable_id"], name: "index_events_on_eventable"
  end

  create_table "feedbacks", force: :cascade do |t|
    t.string "feedbackable_type"
    t.bigint "feedbackable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["feedbackable_type", "feedbackable_id"], name: "index_feedbacks_on_feedbackable"
  end

  create_table "groups", force: :cascade do |t|
    t.string "title", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "groups_users", id: false, force: :cascade do |t|
    t.bigint "group_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_groups_users_on_group_id"
    t.index ["user_id"], name: "index_groups_users_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.string "title", null: false
    t.string "message", null: false
    t.boolean "has_read", default: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "preferences", force: :cascade do |t|
    t.boolean "dark_mode", default: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_preferences_on_user_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "locked", default: false
    t.string "description", default: ""
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource"
  end

  create_table "sections", force: :cascade do |t|
    t.string "title"
    t.bigint "course_id"
    t.integer "days"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_sections_on_course_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "slots", force: :cascade do |t|
    t.date "date"
    t.string "day"
    t.time "start_time"
    t.time "end_time"
    t.integer "recurrent"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_slots_on_user_id"
  end

  create_table "status_transition_histories", force: :cascade do |t|
    t.string "from", null: false
    t.string "to", null: false
    t.string "event", null: false
    t.string "reason", null: false
    t.string "historic_type"
    t.bigint "historic_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["historic_type", "historic_id"], name: "index_status_transition_histories_on_historic"
  end

  create_table "synchronization_records", force: :cascade do |t|
    t.bigint "user_id"
    t.string "sync_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_synchronization_records_on_user_id"
  end

  create_table "syncs", force: :cascade do |t|
    t.bigint "supervisor_id"
    t.bigint "trainee_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["supervisor_id"], name: "index_syncs_on_supervisor_id"
    t.index ["trainee_id"], name: "index_syncs_on_trainee_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.string "name"
    t.bigint "section_id"
    t.integer "duration"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["section_id"], name: "index_tasks_on_section_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name", default: "", null: false
    t.boolean "active", default: true
    t.string "access_token"
    t.datetime "expires_at"
    t.string "refresh_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  create_table "watch_records", force: :cascade do |t|
    t.string "external_id", null: false
    t.string "resource_id", null: false
    t.string "resource_uri", null: false
    t.string "token", null: false
    t.datetime "expiration", null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_watch_records_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "evaluations", "enrollments"
  add_foreign_key "evaluations", "tasks"
  add_foreign_key "evaluations", "users", column: "evaluator_id"
  add_foreign_key "sections", "courses"
  add_foreign_key "synchronization_records", "users"
  add_foreign_key "syncs", "users", column: "supervisor_id"
  add_foreign_key "syncs", "users", column: "trainee_id"
  add_foreign_key "tasks", "sections"
  add_foreign_key "watch_records", "users"
end
