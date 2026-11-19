ActiveRecord::Schema[8.0].define(version: 2026_01_01_000001) do
  enable_extension "plpgsql"

  create_table "bookings", force: :cascade do |t|
    t.string "guest", null: false
    t.date "night", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
  end
end
