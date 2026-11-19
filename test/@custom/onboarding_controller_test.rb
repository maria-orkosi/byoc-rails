require "test_helper"

class OnboardingControllerTest < ActionDispatch::IntegrationTest
  setup do
    @headers = { "Content-Type" => "application/json" }
  end

  test "GET /api/onboarding returns not_started for new account" do
    get "/api/onboarding", headers: @headers
    assert_response :ok
    body = JSON.parse(response.body)
    assert_equal "not_started", body["status"]
    assert_nil body["current_step"]
    assert_not body["completed"]
  end

  test "POST /api/onboarding/start creates a new onboarding state" do
    assert_difference("OnboardingState.count", 1) do
      post "/api/onboarding/start", headers: @headers
    end
    assert_response :created
    body = JSON.parse(response.body)
    assert_equal "in_progress", body["status"]
    assert_equal "welcome", body["current_step"]
    assert_not body["completed"]
  end

  test "POST /api/onboarding/start is idempotent for existing account" do
    post "/api/onboarding/start", headers: @headers
    assert_response :created

    assert_no_difference("OnboardingState.count") do
      post "/api/onboarding/start", headers: @headers
    end
    assert_response :created
  end

  test "POST /api/onboarding/advance moves to next step" do
    post "/api/onboarding/start", headers: @headers
    assert_response :created

    post "/api/onboarding/advance", headers: @headers
    assert_response :ok
    body = JSON.parse(response.body)
    assert_equal "profile", body["current_step"]
    assert_equal "in_progress", body["status"]
  end

  test "POST /api/onboarding/advance through all steps completes onboarding" do
    post "/api/onboarding/start", headers: @headers
    assert_response :created

    # Advance through: welcome -> profile -> preferences -> complete
    3.times do
      post "/api/onboarding/advance", headers: @headers
      assert_response :ok
    end

    body = JSON.parse(response.body)
    assert_equal "completed", body["status"]
    assert body["completed"]
    assert body["completed_at"].present?
  end

  test "POST /api/onboarding/skip completes the onboarding immediately" do
    post "/api/onboarding/start", headers: @headers
    assert_response :created

    post "/api/onboarding/skip", headers: @headers
    assert_response :ok
    body = JSON.parse(response.body)
    assert_equal "completed", body["status"]
    assert body["completed"]
  end

  test "POST /api/onboarding/advance returns not_found when onboarding not started" do
    post "/api/onboarding/advance", headers: @headers
    assert_response :not_found
    body = JSON.parse(response.body)
    assert_equal "Onboarding not started", body["error"]
  end

  test "POST /api/onboarding/skip returns not_found when onboarding not started" do
    post "/api/onboarding/skip", headers: @headers
    assert_response :not_found
    body = JSON.parse(response.body)
    assert_equal "Onboarding not started", body["error"]
  end

  test "onboarding state is isolated per account (by IP)" do
    # Simulate different accounts by using different remote IPs
    # The controller uses request.remote_ip for account resolution
    post "/api/onboarding/start", headers: @headers.merge("REMOTE_ADDR" => "1.1.1.1")
    assert_response :created

    post "/api/onboarding/start", headers: @headers.merge("REMOTE_ADDR" => "2.2.2.2")
    assert_response :created

    post "/api/onboarding/advance", headers: @headers.merge("REMOTE_ADDR" => "1.1.1.1")
    assert_response :ok

    # Account B is still on welcome
    get "/api/onboarding", headers: @headers.merge("REMOTE_ADDR" => "2.2.2.2")
    assert_response :ok
    body = JSON.parse(response.body)
    assert_equal "welcome", body["current_step"]

    # Account A is on profile
    get "/api/onboarding", headers: @headers.merge("REMOTE_ADDR" => "1.1.1.1")
    assert_response :ok
    body = JSON.parse(response.body)
    assert_equal "profile", body["current_step"]
  end
end