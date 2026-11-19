require_relative "../spec_helper"

RSpec.describe "Sessions", type: :request do
  describe "GET /login" do
    it "returns the login page" do
      get "/login"

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Sign in")
    end
  end

  describe "GET /login/create" do
    it "redirects with alert when user_id is missing" do
      get "/login/create"

      expect(response).to have_http_status(:found)
      expect(response).to redirect_to("/login")
    end
  end
end