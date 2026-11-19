class CreateOnboardingStates < ActiveRecord::Migration[8.0]
  def change
    create_table :onboarding_states do |t|
      t.string :account_id, null: false
      t.string :current_step, null: false, default: "welcome"
      t.boolean :completed, null: false, default: false
      t.datetime :completed_at
      t.timestamps
    end

    add_index :onboarding_states, :account_id, unique: true
  end
end