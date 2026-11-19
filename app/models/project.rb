class Project < ApplicationRecord
  validates :name, presence: true

  has_many :project_components, -> { order(:position) }, dependent: :destroy
  has_many :components, through: :project_components
  has_many :component_groups, dependent: :destroy
end