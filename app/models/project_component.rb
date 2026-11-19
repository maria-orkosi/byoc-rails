class ProjectComponent < ApplicationRecord
  belongs_to :project
  belongs_to :component
  belongs_to :component_group, optional: true

  validates :component_id, uniqueness: { scope: :project_id }
end