class Component < ApplicationRecord
  validates :name, presence: true

  has_many :project_components, dependent: :destroy
  has_many :projects, through: :project_components

  scope :search, ->(query) {
    return all if query.blank?
    where("name ILIKE :q OR description ILIKE :q", q: "%#{query}%")
  }
end