require_relative "../spec_helper"

RSpec.describe Project, type: :model do
  let(:user) { User.create!(email: "project-test@example.com") }

  describe "validations" do
    it "is valid with all required fields" do
      project = Project.new(
        user: user,
        name: "Valid Project",
        database_choice: "postgresql",
        commit_message: "Initial commit"
      )
      expect(project).to be_valid
    end

    it "is invalid without a name" do
      project = Project.new(
        user: user,
        name: nil,
        database_choice: "postgresql",
        commit_message: "init"
      )
      expect(project).not_to be_valid
      expect(project.errors[:name]).to include("can't be blank")
    end

    it "is invalid without a database choice" do
      project = Project.new(
        user: user,
        name: "Test",
        database_choice: nil,
        commit_message: "init"
      )
      expect(project).not_to be_valid
    end
  end

  describe "associations" do
    it "belongs to a user" do
      project = Project.create!(
        user: user,
        name: "Assoc Project",
        database_choice: "postgresql",
        commit_message: "init"
      )
      expect(project.user).to eq(user)
    end
  end

  describe "defaults" do
    it "has status 'scaffolded' by default" do
      project = Project.create!(
        user: user,
        name: "Default Project",
        database_choice: "mysql",
        commit_message: "init"
      )
      expect(project.status).to eq("scaffolded")
    end

    it "has empty gems array by default" do
      project = Project.create!(
        user: user,
        name: "Gems Project",
        database_choice: "sqlite",
        commit_message: "init"
      )
      expect(project.gems).to eq([])
    end
  end

  describe "scope" do
    it "orders by created_at descending" do
      p1 = Project.create!(user: user, name: "Older", database_choice: "postgresql", commit_message: "x")
      p2 = Project.create!(user: user, name: "Newer", database_choice: "mysql", commit_message: "y")
      expect(Project.ordered.first).to eq(p2)
    end
  end
end