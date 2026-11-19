require_relative "../spec_helper"

RSpec.describe "Components API", type: :request do
  describe "GET /api/components" do
    it "returns 401 when not authenticated" do
      get "/api/components"

      expect(response).to have_http_status(:unauthorized)
      body = JSON.parse(response.body)
      expect(body["error"]).to eq("Unauthorized")
    end

    context "when authenticated" do
      let(:user) { User.create!(email: "test@example.com") }

      before do
        post "/login", params: { email: user.email }
      end

      it "returns an empty array when no components exist" do
        get "/api/components"

        expect(response).to have_http_status(:ok)

        body = JSON.parse(response.body)
        expect(body).to be_an(Array)
        expect(body).to be_empty
      end

      context "when components exist" do
        before do
          Component.create!(name: "Auth Service", status: "active")
          Component.create!(name: "Database", status: "inactive")
        end

        it "returns all components ordered by id" do
          get "/api/components"

          expect(response).to have_http_status(:ok)

          body = JSON.parse(response.body)
          expect(body.length).to eq(2)
          expect(body[0]["name"]).to eq("Auth Service")
          expect(body[0]["status"]).to eq("active")
          expect(body[1]["name"]).to eq("Database")
          expect(body[1]["status"]).to eq("inactive")
        end
      end
    end
  end
end