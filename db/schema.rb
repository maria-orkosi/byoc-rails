ActiveRecord::Schema[8.0].define(version: 2026_11_19_000001) do
  enable_extension "plpgsql"

  create_table "bookings", force: :cascade do |t|
    t.string "guest", null: false
    t.date "night", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "waiting_list_entries", force: :cascade do |t|
    t.string "email", null: false
    t.datetime "subscribed_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_waiting_list_entries_on_email", unique: true
  end
end
