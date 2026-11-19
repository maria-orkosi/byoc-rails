class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.integer :onboarding_step, default: 0
      t.boolean :onboarding_completed, default: false
      t.timestamps
    end

    add_index :users, :email, unique: true
  end
end