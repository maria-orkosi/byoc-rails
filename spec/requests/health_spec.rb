require_relative "../spec_helper"

RSpec.describe "Health Check", type: :request do
  describe "GET /health" do
    before do
      # Ensure $START_TIME is set for this test run
      $START_TIME = Time.now unless defined?($START_TIME) && $START_TIME
    end

    context "when all dependencies are healthy" do
      before do
        allow(ActiveRecord::Base.connection).to receive(:active?).and_return(true)
        allow_any_instance_of(Redis).to receive(:ping).and_return("PONG")
      end

      it "returns HTTP 200 with ok status" do
        get "/health"

        expect(response).to have_http_status(:ok)

        body = JSON.parse(response.body)
        expect(body["status"]).to eq("ok")
        expect(body["uptime"]).to be_a(Numeric)
        expect(body["uptime"]).to be >= 0
        expect(body["checks"]).to be_a(Hash)
        expect(body["checks"]["db"]).to eq("ok")
        expect(body["checks"]["redis"]).to eq("ok")
        expect(body["timestamp"]).to be_a(String)
      end
    end

    context "when a dependency is down" do
      before do
        allow(ActiveRecord::Base.connection).to receive(:active?).and_return(false)
        allow_any_instance_of(Redis).to receive(:ping).and_return("PONG")
      end

      it "returns HTTP 503 with error status and identifies failing check" do
        get "/health"

        expect(response).to have_http_status(:service_unavailable)

        body = JSON.parse(response.body)
        expect(body["status"]).to eq("error")
        expect(body["checks"]["db"]).to eq("error")
        expect(body["checks"]["redis"]).to eq("ok")
      end
    end

    context "when redis is down" do
      before do
        allow(ActiveRecord::Base.connection).to receive(:active?).and_return(true)
        allow_any_instance_of(Redis).to receive(:ping).and_raise(Redis::CannotConnectError)
      end

      it "returns HTTP 503 with error status and identifies failing redis check" do
        get "/health"

        expect(response).to have_http_status(:service_unavailable)

        body = JSON.parse(response.body)
        expect(body["status"]).to eq("error")
        expect(body["checks"]["db"]).to eq("ok")
        expect(body["checks"]["redis"]).to eq("error")
      end
    end

    context "uptime tracking" do
      before do
        allow(ActiveRecord::Base.connection).to receive(:active?).and_return(true)
        allow_any_instance_of(Redis).to receive(:ping).and_return("PONG")
      end

      it "increments across requests" do
        get "/health"
        first_uptime = JSON.parse(response.body)["uptime"]

        sleep 1

        get "/health"
        second_uptime = JSON.parse(response.body)["uptime"]

        expect(second_uptime).to be > first_uptime
      end
    end
  end

  describe "GET /up" do
    before do
      allow(ActiveRecord::Base.connection).to receive(:active?).and_return(true)
    end

    it "returns HTTP 200 with ok status (DB-only liveness check)" do
      get "/up"

      expect(response).to have_http_status(:ok)

      body = JSON.parse(response.body)
      expect(body["status"]).to eq("ok")
      expect(body["checks"]["db"]).to eq("ok")
      expect(body["checks"]).not_to have_key("redis")
    end

    it "returns HTTP 503 when database is down" do
      allow(ActiveRecord::Base.connection).to receive(:active?).and_return(false)

      get "/up"

      expect(response).to have_http_status(:service_unavailable)

      body = JSON.parse(response.body)
      expect(body["status"]).to eq("error")
      expect(body["checks"]["db"]).to eq("error")
    end
  end
end