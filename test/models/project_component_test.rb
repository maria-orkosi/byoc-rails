require "test_helper"

class ProjectComponentTest < ActiveSupport::TestCase
  setup do
    @project = Project.create!(name: "Test Project")
    @component = Component.create!(name: "Button")
  end

  test "valid project_component" do
    pc = ProjectComponent.new(project: @project, component: @component)
    assert pc.valid?
  end

  test "unique component per project" do
    ProjectComponent.create!(project: @project, component: @component)
    duplicate = ProjectComponent.new(project: @project, component: @component)
    assert_not duplicate.valid?
  end

  test "belongs to optional component_group" do
    group = ComponentGroup.create!(project: @project, name: "UI Kit")
    pc = ProjectComponent.create!(project: @project, component: @component, component_group: group)
    assert_equal group, pc.component_group
  end

  test "can have nil component_group" do
    pc = ProjectComponent.create!(project: @project, component: @component, component_group: nil)
    assert_nil pc.component_group
  end
end