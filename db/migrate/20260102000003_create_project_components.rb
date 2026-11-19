class CreateProjectComponents < ActiveRecord::Migration[8.0]
  def change
    create_table :project_components do |t|
      t.references :project, null: false, foreign_key: true
      t.references :component, null: false, foreign_key: true
      t.references :component_group, foreign_key: true
      t.integer :position, null: false, default: 0

      t.timestamps
    end

    add_index :project_components, [:project_id, :component_id], unique: true
  end
end