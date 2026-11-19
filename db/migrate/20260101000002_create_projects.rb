class CreateProjects < ActiveRecord::Migration[8.0]
  def change
    create_table :projects do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.string :database_choice, null: false
      t.text :gems, array: true, default: []
      t.string :commit_message
      t.string :status, default: "scaffolded"
      t.timestamps
    end
  end
end