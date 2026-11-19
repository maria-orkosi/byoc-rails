class AddNameAndStatusToWaitingListEntries < ActiveRecord::Migration[8.0]
  def change
    add_column :waiting_list_entries, :name, :string
    add_column :waiting_list_entries, :status, :string, default: "active", null: false
    add_index :waiting_list_entries, :status
  end
end