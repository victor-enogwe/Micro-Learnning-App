# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_09_02_214114) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.string "description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["description"], name: "index_categories_on_description"
    t.index ["name"], name: "index_categories_on_name", unique: true
  end

  create_table "courses", force: :cascade do |t|
    t.bigint "category_id", null: false
    t.bigint "creator_id", null: false
    t.string "title", null: false
    t.string "description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_courses_on_category_id"
    t.index ["creator_id"], name: "index_courses_on_creator_id"
    t.index ["title"], name: "index_courses_on_title"
  end

  create_table "instructor_requests", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.boolean "approved", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_instructor_requests_on_user_id"
  end

  create_table "permissions", force: :cascade do |t|
    t.string "name", null: false
    t.index ["name"], name: "index_permissions_on_name", unique: true
  end

  create_table "role_permissions", force: :cascade do |t|
    t.bigint "role_id", null: false
    t.bigint "permission_id", null: false
    t.index ["permission_id"], name: "index_role_permissions_on_permission_id"
    t.index ["role_id"], name: "index_role_permissions_on_role_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name", null: false
    t.index ["name"], name: "index_roles_on_name", unique: true
  end

  create_table "topics", force: :cascade do |t|
    t.bigint "course_id", null: false
    t.string "title", null: false
    t.string "description", null: false
    t.string "url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_topics_on_course_id"
    t.index ["description"], name: "index_topics_on_description"
    t.index ["title"], name: "index_topics_on_title"
  end

  create_table "user_courses", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "course_id", null: false
    t.datetime "registration_date", null: false
    t.integer "learning_interval_days", default: 2, null: false
    t.integer "daily_delivery_time", default: 24, null: false
    t.datetime "last_sent_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_user_courses_on_course_id"
    t.index ["daily_delivery_time"], name: "index_user_courses_on_daily_delivery_time"
    t.index ["last_sent_time"], name: "index_user_courses_on_last_sent_time"
    t.index ["learning_interval_days"], name: "index_user_courses_on_learning_interval_days"
    t.index ["user_id"], name: "index_user_courses_on_user_id"
  end

  create_table "user_permissions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "permission_id", null: false
    t.index ["permission_id"], name: "index_user_permissions_on_permission_id"
    t.index ["user_id"], name: "index_user_permissions_on_user_id"
  end

  create_table "user_topics", force: :cascade do |t|
    t.bigint "course_id", null: false
    t.bigint "topic_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_user_topics_on_course_id"
    t.index ["topic_id"], name: "index_user_topics_on_topic_id"
    t.index ["user_id"], name: "index_user_topics_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "fname", null: false
    t.string "lname", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["fname"], name: "index_users_on_fname"
    t.index ["lname"], name: "index_users_on_lname"
  end

  add_foreign_key "courses", "categories"
  add_foreign_key "courses", "users", column: "creator_id"
  add_foreign_key "instructor_requests", "users", on_delete: :cascade
  add_foreign_key "role_permissions", "permissions", on_delete: :cascade
  add_foreign_key "role_permissions", "roles", on_delete: :cascade
  add_foreign_key "topics", "courses", on_delete: :cascade
  add_foreign_key "user_courses", "courses", on_delete: :cascade
  add_foreign_key "user_courses", "users", on_delete: :cascade
  add_foreign_key "user_permissions", "permissions", on_delete: :cascade
  add_foreign_key "user_permissions", "users", on_delete: :cascade
  add_foreign_key "user_topics", "courses", on_delete: :cascade
  add_foreign_key "user_topics", "topics", on_delete: :cascade
  add_foreign_key "user_topics", "users", on_delete: :cascade
end
