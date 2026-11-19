class Project < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :database_choice, presence: true
  validates :commit_message, presence: true, on: :create

  scope :ordered, -> { order(created_at: :desc) }
end