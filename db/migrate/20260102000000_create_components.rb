class CreateComponents < ActiveRecord::Migration[8.0]
  def change
    create_table :components do |t|
      t.string :name, null: false
      t.text :description
      t.string :preview_url
      t.string :version
      t.string :compatibility
      t.jsonb :dependencies, default: []

      t.timestamps
    end

    add_index :components, :name
  end
end