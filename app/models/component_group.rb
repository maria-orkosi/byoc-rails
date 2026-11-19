class ComponentGroup < ApplicationRecord
  belongs_to :project
  has_many :project_components, dependent: :nullify

  validates :name, presence: true
  validates :name, uniqueness: { scope: :project_id }
end