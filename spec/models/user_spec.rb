require_relative "../spec_helper"

RSpec.describe User, type: :model do
  describe "validations" do
    it "is valid with an email" do
      user = User.new(email: "test@example.com")
      expect(user).to be_valid
    end

    it "is invalid without an email" do
      user = User.new(email: nil)
      expect(user).not_to be_valid
    end

    it "is invalid with a duplicate email" do
      User.create!(email: "dup@example.com")
      user = User.new(email: "dup@example.com")
      expect(user).not_to be_valid
    end
  end

  describe "#has_projects?" do
    it "returns false when user has no projects" do
      user = User.create!(email: "noprojects@example.com")
      expect(user.has_projects?).to be false
    end

    it "returns true when user has projects" do
      user = User.create!(email: "hasprojects@example.com")
      user.projects.create!(name: "Test", database_choice: "postgresql", commit_message: "init")
      expect(user.has_projects?).to be true
    end
  end

  describe "#onboarding_completed?" do
    it "returns false by default" do
      user = User.create!(email: "new@example.com")
      expect(user.onboarding_completed?).to be false
    end

    it "returns true when onboarding is completed" do
      user = User.create!(email: "done@example.com", onboarding_completed: true)
      expect(user.onboarding_completed?).to be true
    end
  end

  describe "associations" do
    it "has many projects" do
      user = User.create!(email: "assoc@example.com")
      p1 = user.projects.create!(name: "P1", database_choice: "postgresql", commit_message: "init")
      p2 = user.projects.create!(name: "P2", database_choice: "mysql", commit_message: "start")
      expect(user.projects.count).to eq(2)
    end

    it "destroys dependent projects" do
      user = User.create!(email: "destroy@example.com")
      user.projects.create!(name: "ToDelete", database_choice: "sqlite", commit_message: "x")
      expect { user.destroy }.to change(Project, :count).by(-1)
    end
  end
end