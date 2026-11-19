class CreateWaitingListEntries < ActiveRecord::Migration[8.0]
  def change
    create_table :waiting_list_entries do |t|
      t.string :email, null: false
      t.datetime :subscribed_at, null: false

      t.timestamps
    end

    add_index :waiting_list_entries, :email, unique: true
  end
end