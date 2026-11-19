require "test_helper"

class ComponentGroupTest < ActiveSupport::TestCase
  setup do
    @project = Project.create!(name: "Test Project")
  end

  test "valid group" do
    group = ComponentGroup.new(project: @project, name: "UI Kit")
    assert group.valid?
  end

  test "invalid without name" do
    group = ComponentGroup.new(project: @project)
    assert_not group.valid?
  end

  test "unique name per project" do
    ComponentGroup.create!(project: @project, name: "UI Kit")
    duplicate = ComponentGroup.new(project: @project, name: "UI Kit")
    assert_not duplicate.valid?
  end

  test "same name allowed across different projects" do
    project2 = Project.create!(name: "Other")
    ComponentGroup.create!(project: @project, name: "UI Kit")
    group2 = ComponentGroup.new(project: project2, name: "UI Kit")
    assert group2.valid?
  end

  test "nullifies project_components on destroy" do
    component = Component.create!(name: "Button")
    group = ComponentGroup.create!(project: @project, name: "UI Kit")
    pc = ProjectComponent.create!(project: @project, component: component, component_group: group)

    group.destroy!
    pc.reload
    assert_nil pc.component_group_id
  end
end