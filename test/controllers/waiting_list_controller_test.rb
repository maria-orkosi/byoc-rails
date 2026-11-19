require "test_helper"

class WaitingListControllerTest < ActionDispatch::IntegrationTest
  test "GET /waiting_list/new returns a successful response" do
    get "/waiting_list/new"
    assert_response :ok
    body = JSON.parse(response.body)
    assert body.key?("message")
  end

  test "POST /waiting_list creates a new entry with valid unique email" do
    assert_difference("WaitingListEntry.count", 1) do
      post "/waiting_list", params: { email: "test@example.com" }.to_json, headers: { "Content-Type" => "application/json" }
    end

    assert_response :created
    body = JSON.parse(response.body)
    assert_equal "You're on the list!", body["message"]

    entry = WaitingListEntry.last
    assert_equal "test@example.com", entry.email
    assert entry.subscribed_at.present?
  end

  test "POST /waiting_list normalizes email before saving" do
    post "/waiting_list", params: { email: "  Test@Example.COM  " }.to_json, headers: { "Content-Type" => "application/json" }

    assert_response :created
    body = JSON.parse(response.body)
    assert_equal "You're on the list!", body["message"]
    assert_equal "test@example.com", WaitingListEntry.last.email
  end

  test "POST /waiting_list returns error for invalid email format" do
    assert_no_difference("WaitingListEntry.count") do
      post "/waiting_list", params: { email: "not-an-email" }.to_json, headers: { "Content-Type" => "application/json" }
    end

    assert_response :unprocessable_entity
    body = JSON.parse(response.body)
    assert_equal "Please enter a valid email", body["message"]
  end

  test "POST /waiting_list returns error for blank email" do
    assert_no_difference("WaitingListEntry.count") do
      post "/waiting_list", params: { email: "" }.to_json, headers: { "Content-Type" => "application/json" }
    end

    assert_response :unprocessable_entity
    body = JSON.parse(response.body)
    assert_equal "Please enter a valid email", body["message"]
  end

  test "POST /waiting_list returns already-on-list for duplicate email" do
    WaitingListEntry.create!(email: "already@example.com", subscribed_at: Time.current)

    assert_no_difference("WaitingListEntry.count") do
      post "/waiting_list", params: { email: "already@example.com" }.to_json, headers: { "Content-Type" => "application/json" }
    end

    assert_response :ok
    body = JSON.parse(response.body)
    assert_equal "You're already on the list!", body["message"]
  end

  test "POST /waiting_list handles duplicate with different case" do
    WaitingListEntry.create!(email: "already@example.com", subscribed_at: Time.current)

    assert_no_difference("WaitingListEntry.count") do
      post "/waiting_list", params: { email: "ALREADY@EXAMPLE.COM" }.to_json, headers: { "Content-Type" => "application/json" }
    end

    assert_response :ok
    body = JSON.parse(response.body)
    assert_equal "You're already on the list!", body["message"]
  end

  test "POST /waiting_list does not require authentication" do
    post "/waiting_list", params: { email: "anon@example.com" }.to_json, headers: { "Content-Type" => "application/json" }

    assert_response :created
  end

  test "GET /api/waiting_list/new returns successful response under /api scope" do
    get "/api/waiting_list/new"
    assert_response :ok
  end

  test "POST /api/waiting_list creates entry via /api scope" do
    assert_difference("WaitingListEntry.count", 1) do
      post "/api/waiting_list", params: { email: "api@example.com" }.to_json, headers: { "Content-Type" => "application/json" }
    end

    assert_response :created
  end
end