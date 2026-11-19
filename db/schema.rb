ActiveRecord::Schema[8.0].define(version: 2026_01_03_000000) do
  enable_extension "plpgsql"

  create_table "bookings", force: :cascade do |t|
    t.string "guest", null: false
    t.date "night", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "components", force: :cascade do |t|
    t.string "name", null: false
    t.string "status", default: "unknown"
    t.datetime "last_deployed_at"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_components_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "components", "users"
end
