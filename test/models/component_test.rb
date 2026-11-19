require "test_helper"

class ComponentTest < ActiveSupport::TestCase
  test "valid component with name" do
    component = Component.new(name: "TestButton", description: "A test button")
    assert component.valid?
  end

  test "invalid without name" do
    component = Component.new(description: "No name")
    assert_not component.valid?
    assert_includes component.errors[:name], "can't be blank"
  end

  test "search scope filters by name" do
    c1 = Component.create!(name: "AlphaButton", description: "First")
    c2 = Component.create!(name: "BetaCard", description: "Second")

    results = Component.search("Alpha")
    assert_includes results, c1
    assert_not_includes results, c2
  end

  test "search scope filters by description" do
    c1 = Component.create!(name: "Alpha", description: "A unique widget")
    c2 = Component.create!(name: "Beta", description: "Something else")

    results = Component.search("unique widget")
    assert_includes results, c1
    assert_not_includes results, c2
  end

  test "search scope is case insensitive" do
    c1 = Component.create!(name: "AlphaButton", description: "Desc")
    assert_includes Component.search("alphabutton"), c1
  end

  test "search scope returns all when blank" do
    c1 = Component.create!(name: "Alpha")
    c2 = Component.create!(name: "Beta")
    assert_equal 2, Component.search("").count
    assert_equal 2, Component.search(nil).count
  end
end