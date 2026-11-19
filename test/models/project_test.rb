require "test_helper"

class ProjectTest < ActiveSupport::TestCase
  test "valid project with name" do
    project = Project.new(name: "My Project")
    assert project.valid?
  end

  test "invalid without name" do
    project = Project.new
    assert_not project.valid?
  end

  test "has many project_components" do
    project = Project.create!(name: "Test")
    component = Component.create!(name: "Button")
    pc = ProjectComponent.create!(project: project, component: component)

    assert_equal 1, project.project_components.count
    assert_equal [component], project.components
  end

  test "has many component_groups" do
    project = Project.create!(name: "Test")
    group = ComponentGroup.create!(project: project, name: "UI Kit")

    assert_equal 1, project.component_groups.count
  end

  test "destroying project cleans up associations" do
    project = Project.create!(name: "Test")
    component = Component.create!(name: "Button")
    ProjectComponent.create!(project: project, component: component)
    ComponentGroup.create!(project: project, name: "Group")

    assert_difference("ProjectComponent.count", -1) do
      assert_difference("ComponentGroup.count", -1) do
        project.destroy!
      end
    end
  end
end