require_relative "../spec_helper"

RSpec.describe "Dashboard", type: :request do
  describe "GET /dashboard" do
    it "returns 404 since dashboard UI is served by the React frontend" do
      get "/dashboard"

      expect(response).to have_http_status(:not_found)
    end
  end
end