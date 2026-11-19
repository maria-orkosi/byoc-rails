require_relative "../spec_helper"

RSpec.describe "Sessions", type: :request do
  describe "GET /login" do
    it "returns the login endpoint" do
      get "/login"

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body["message"]).to eq("Login page")
    end
  end

  describe "POST /login" do
    it "redirects with alert when email is missing" do
      post "/login"

      expect(response).to have_http_status(:found)
      expect(response).to redirect_to("/login")
    end

    context "with valid user" do
      let(:user) { User.create!(email: "test@example.com") }

      it "logs the user in and redirects" do
        post "/login", params: { email: user.email }

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to("/")
        expect(session[:user_id]).to eq(user.id)
      end
    end
  end

  describe "DELETE /logout" do
    let(:user) { User.create!(email: "test@example.com") }

    before do
      post "/login", params: { email: user.email }
    end

    it "logs the user out" do
      delete "/logout"

      expect(response).to have_http_status(:found)
      expect(response).to redirect_to("/login")
      expect(session[:user_id]).to be_nil
    end
  end
end