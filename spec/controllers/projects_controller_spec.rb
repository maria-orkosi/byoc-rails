require_relative "../spec_helper"

RSpec.describe ProjectsController, type: :controller do
  render_views

  let(:user) { User.create!(email: "test@byoc-rails.dev") }

  before do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  describe "GET #index" do
    context "when user has no projects and onboarding not completed" do
      it "redirects to onboarding" do
        get :index
        expect(response).to redirect_to(onboarding_path(step: 1))
      end
    end

    context "when user has projects" do
      before do
        user.projects.create!(name: "Project One", database_choice: "postgresql", commit_message: "init")
        user.projects.create!(name: "Project Two", database_choice: "mysql", commit_message: "start")
      end

      it "renders the index template" do
        get :index
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Project One")
        expect(response.body).to include("Project Two")
      end

      it "returns projects as JSON" do
        get :index, params: { format: :json }
        expect(response).to have_http_status(:ok)
        body = JSON.parse(response.body)
        expect(body.length).to eq(2)
        expect(body[0]["name"]).to eq("Project Two") # ordered desc
      end
    end
  end

  describe "GET #show" do
    let(:project) { user.projects.create!(name: "My Project", database_choice: "postgresql", commit_message: "init") }

    before { user.update!(onboarding_completed: true) }

    it "renders the show template" do
      get :show, params: { id: project.id }
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("My Project")
    end

    it "returns project as JSON" do
      get :show, params: { id: project.id, format: :json }
      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body["name"]).to eq("My Project")
    end

    it "returns 404 for non-existent project" do
      get :show, params: { id: 99999 }
      expect(response).to redirect_to(projects_path)
    end
  end
end