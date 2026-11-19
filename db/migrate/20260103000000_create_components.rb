class CreateComponents < ActiveRecord::Migration[8.0]
  def change
    create_table :components do |t|
      t.string :name, null: false
      t.string :status, default: "unknown"
      t.datetime :last_deployed_at
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end