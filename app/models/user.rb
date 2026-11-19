class User < ApplicationRecord
  has_many :projects, dependent: :destroy

  validates :email, presence: true, uniqueness: true

  def onboarding_completed?
    onboarding_completed
  end

  def has_projects?
    projects.any?
  end
end