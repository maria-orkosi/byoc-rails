require_relative "../spec_helper"

RSpec.describe ProjectGenerator do
  let(:user) { User.create!(email: "generator-test@example.com") }

  describe "#call" do
    let(:data) do
      {
        project_name: "Generated Project",
        database_choice: "postgresql",
        gems: ["devise", "rspec"],
        commit_message: "Initial scaffold"
      }
    end

    it "creates a project for the user" do
      expect {
        ProjectGenerator.new(user, data).call
      }.to change(Project, :count).by(1)
    end

    it "sets the correct attributes on the project" do
      project = ProjectGenerator.new(user, data).call
      expect(project.name).to eq("Generated Project")
      expect(project.database_choice).to eq("postgresql")
      expect(project.gems).to include("devise", "rspec")
      expect(project.commit_message).to eq("Initial scaffold")
      expect(project.status).to eq("scaffolded")
      expect(project.user).to eq(user)
    end

    it "handles empty gems" do
      data_no_gems = data.merge(gems: [])
      project = ProjectGenerator.new(user, data_no_gems).call
      expect(project.gems).to eq([])
    end

    it "returns the created project" do
      project = ProjectGenerator.new(user, data).call
      expect(project).to be_a(Project)
      expect(project).to be_persisted
    end
  end
end