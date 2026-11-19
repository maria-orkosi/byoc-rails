require_relative "../spec_helper"

RSpec.describe "Dashboard", type: :request do
  describe "GET /dashboard" do
    context "when not logged in" do
      it "redirects to login page" do
        get "/dashboard"

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to("/login")
      end
    end
  end
end