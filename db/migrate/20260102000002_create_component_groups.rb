class CreateComponentGroups < ActiveRecord::Migration[8.0]
  def change
    create_table :component_groups do |t|
      t.references :project, null: false, foreign_key: true
      t.string :name, null: false

      t.timestamps
    end

    add_index :component_groups, [:project_id, :name], unique: true
  end
end