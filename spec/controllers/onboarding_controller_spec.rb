require_relative "../spec_helper"

RSpec.describe OnboardingController, type: :controller do
  render_views

  let(:user) { User.create!(email: "test@byoc-rails.dev") }

  before do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  describe "GET #show" do
    context "when user has no projects and onboarding not completed" do
      it "renders the show template with step 1" do
        get :show, params: { step: 1 }
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Name Your Project")
      end
    end

    context "when user has projects" do
      before { user.projects.create!(name: "Test", database_choice: "postgresql", commit_message: "init") }

      it "redirects to projects path" do
        get :show, params: { step: 1 }
        expect(response).to redirect_to(projects_path)
      end
    end

    context "when user has onboarding completed" do
      before { user.update!(onboarding_completed: true) }

      it "redirects to projects path" do
        get :show, params: { step: 1 }
        expect(response).to redirect_to(projects_path)
      end
    end

    context "JSON format" do
      it "returns step and onboarding data as JSON" do
        get :show, params: { step: 1, format: :json }
        expect(response).to have_http_status(:ok)
        body = JSON.parse(response.body)
        expect(body["step"]).to eq(1)
        expect(body).to have_key("onboarding_data")
        expect(body["has_projects"]).to eq(false)
      end
    end
  end

  describe "PATCH #update" do
    context "step 1 with valid data" do
      it "advances to step 2" do
        patch :update, params: { step: 1, project_name: "My Project" }
        expect(response).to redirect_to(onboarding_path(step: 2))
        expect(user.reload.onboarding_step).to eq(2)
      end
    end

    context "step 1 with invalid data" do
      it "re-renders show with error" do
        patch :update, params: { step: 1, project_name: "" }
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Please fix the errors below")
      end

      it "returns errors as JSON" do
        patch :update, params: { step: 1, project_name: "", format: :json }
        expect(response).to have_http_status(:unprocessable_entity)
        body = JSON.parse(response.body)
        expect(body["errors"]).to have_key("project_name")
      end
    end

    context "step 2 with valid data" do
      before do
        session[:onboarding_data] = { project_name: "My Project" }
        user.update!(onboarding_step: 2)
      end

      it "advances to step 3" do
        patch :update, params: { step: 2, database_choice: "postgresql" }
        expect(response).to redirect_to(onboarding_path(step: 3))
      end
    end

    context "step 3 with optional gems" do
      before do
        session[:onboarding_data] = { project_name: "My Project", database_choice: "postgresql" }
        user.update!(onboarding_step: 3)
      end

      it "advances to step 4" do
        patch :update, params: { step: 3, gems: ["devise", "rspec"] }
        expect(response).to redirect_to(onboarding_path(step: 4))
      end
    end

    context "step 4 (final step) with valid data" do
      before do
        session[:onboarding_data] = {
          project_name: "My Project",
          database_choice: "postgresql",
          gems: ["devise"],
        }
        user.update!(onboarding_step: 4)
      end

      it "creates project and redirects to project page" do
        expect {
          patch :update, params: { step: 4, commit_message: "Initial commit" }
        }.to change(Project, :count).by(1)

        project = Project.last
        expect(response).to redirect_to(project_path(project))
        expect(project.name).to eq("My Project")
        expect(project.database_choice).to eq("postgresql")
        expect(project.gems).to include("devise")
        expect(project.commit_message).to eq("Initial commit")
        expect(user.reload.onboarding_completed).to be true
      end

      it "returns JSON with redirect on success" do
        patch :update, params: { step: 4, commit_message: "Initial commit", format: :json }
        expect(response).to have_http_status(:ok)
        body = JSON.parse(response.body)
        expect(body).to have_key("redirect_to")
        expect(body).to have_key("project")
      end
    end

    context "step 4 with invalid data" do
      before do
        session[:onboarding_data] = {
          project_name: "My Project",
          database_choice: "postgresql",
        }
        user.update!(onboarding_step: 4)
      end

      it "returns error for missing commit message" do
        patch :update, params: { step: 4, commit_message: "" }
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Please fix the errors")
      end
    end

    context "back button" do
      before do
        session[:onboarding_data] = { project_name: "My Project" }
        user.update!(onboarding_step: 3)
      end

      it "returns to previous step" do
        patch :update, params: { step: 3, direction: "back" }
        expect(response).to redirect_to(onboarding_path(step: 2))
        expect(user.reload.onboarding_step).to eq(2)
      end
    end

    context "user with existing projects" do
      before { user.projects.create!(name: "Existing", database_choice: "postgresql", commit_message: "init") }

      it "redirects to projects" do
        patch :update, params: { step: 1, project_name: "New Project" }
        expect(response).to redirect_to(projects_path)
      end
    end
  end
end