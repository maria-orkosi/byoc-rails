class CreateBookings < ActiveRecord::Migration[8.0]
  def change
    create_table :bookings do |t|
      t.string :guest, null: false
      t.date :night, null: false
      t.timestamps
    end
  end
end
