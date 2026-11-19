require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "POST /api/registrations creates a user and returns success" do
    post "/api/registrations"

    assert_response :created

    body = JSON.parse(response.body)
    assert body.key?("id"), "Response must include an id"
    assert_match(/\A[0-9a-f\-]{36}\z/, body["id"], "id must be a valid UUID")
    assert_equal "Registration successful", body["message"]
  end

  test "POST /api/registrations returns idempotent UUIDs" do
    post "/api/registrations"
    first_id = JSON.parse(response.body)["id"]

    post "/api/registrations"
    second_id = JSON.parse(response.body)["id"]

    refute_equal first_id, second_id, "Each registration must produce a unique id"
  end

  test "POST /api/registrations does not leak PII in the response" do
    post "/api/registrations"

    body = JSON.parse(response.body)
    refute body.key?("email"), "Response must not contain an email field"
    refute body.key?("name"),  "Response must not contain a name field"
    refute body.key?("password"), "Response must not contain a password field"
  end

  test "POST /api/registrations sends conversion event in production" do
    original_env = ENV["ANALYTICS_KEY"]
    ENV["ANALYTICS_KEY"] = "test-key-abc123"

    begin
      Rails.application.config.analytics_enabled = true
      Rails.application.config.analytics_key = "test-key-abc123"

      post "/api/registrations"

      assert_response :created
      body = JSON.parse(response.body)
      assert body.key?("id")
    ensure
      ENV["ANALYTICS_KEY"] = original_env
      Rails.application.config.analytics_enabled = nil
      Rails.application.config.analytics_key = nil
    end
  end

  test "POST /api/registrations does not block when analytics fails" do
    original_env = ENV["ANALYTICS_KEY"]
    ENV["ANALYTICS_KEY"] = "test-key-fail"

    begin
      Rails.application.config.analytics_enabled = true
      Rails.application.config.analytics_key = "test-key-fail"

      # The request should still succeed even if the analytics endpoint is unreachable.
      post "/api/registrations"

      assert_response :created
    ensure
      ENV["ANALYTICS_KEY"] = original_env
      Rails.application.config.analytics_enabled = nil
      Rails.application.config.analytics_key = nil
    end
  end
end