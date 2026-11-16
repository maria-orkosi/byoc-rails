ActiveRecord::Schema[8.0].define(version: 2026_01_01_000000) do
  enable_extension "plpgsql"

  create_table "bookings", force: :cascade do |t|
    t.string "guest", null: false
    t.date "night", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
end
