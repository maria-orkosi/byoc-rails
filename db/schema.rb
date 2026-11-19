ActiveRecord::Schema[8.0].define(version: 2026_01_01_000002) do
  enable_extension "plpgsql"

  create_table "bookings", force: :cascade do |t|
    t.string "guest", null: false
    t.date "night", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.integer "onboarding_step", default: 0
    t.boolean "onboarding_completed", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "projects", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.string "database_choice", null: false
    t.text "gems", default: [], array: true
    t.string "commit_message"
    t.string "status", default: "scaffolded"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_projects_on_user_id"
  end

  add_foreign_key "projects", "users"
end
