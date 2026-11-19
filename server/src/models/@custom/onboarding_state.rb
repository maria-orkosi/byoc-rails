class OnboardingState < ApplicationRecord
  STEPS = %w[welcome profile preferences complete].freeze

  validates :account_id, presence: true, uniqueness: true
  validates :current_step, presence: true, inclusion: { in: STEPS }
  validates :completed, inclusion: { in: [true, false] }

  scope :for_account, ->(account_id) { where(account_id: account_id) }

  def advance!
    return false if completed?

    current_index = STEPS.index(current_step)
    next_step = STEPS[current_index + 1]

    if next_step.nil? || next_step == "complete"
      update!(current_step: "complete", completed: true, completed_at: Time.current)
    else
      update!(current_step: next_step)
    end
  end

  def skip!
    update!(current_step: "complete", completed: true, completed_at: Time.current)
  end

  def self.start!(account_id:)
    for_account(account_id).first_or_create! do |state|
      state.current_step = "welcome"
      state.completed = false
    end
  end
end