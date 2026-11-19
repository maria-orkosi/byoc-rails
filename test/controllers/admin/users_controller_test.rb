require "test_helper"

class Admin::UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    ENV["ADMIN_API_TOKEN"] = "test-admin-token"
    @admin_headers = { "X-Admin-Token" => "test-admin-token", "Content-Type" => "application/json" }
    @user1 = WaitingListEntry.create!(
      name: "Alice Smith",
      email: "alice@example.com",
      subscribed_at: Time.current,
      status: "active"
    )
    @user2 = WaitingListEntry.create!(
      name: "Bob Jones",
      email: "bob@example.com",
      subscribed_at: 2.days.ago,
      status: "active"
    )
    @deactivated = WaitingListEntry.create!(
      name: "Charlie Brown",
      email: "charlie@example.com",
      subscribed_at: 1.day.ago,
      status: "deactivated"
    )
  end

  teardown do
    ENV.delete("ADMIN_API_TOKEN")
  end

  # Authentication tests
  test "GET /api/admin/users returns 403 without admin token" do
    get "/api/admin/users"
    assert_response :forbidden
    body = JSON.parse(response.body)
    assert_equal "Unauthorized", body["error"]
  end

  test "GET /api/admin/users returns 403 with wrong admin token" do
    get "/api/admin/users", headers: { "X-Admin-Token" => "wrong-token" }
    assert_response :forbidden
  end

  # Index tests
  test "GET /api/admin/users returns paginated list of active users by default" do
    get "/api/admin/users", headers: @admin_headers
    assert_response :ok
    body = JSON.parse(response.body)
    assert body.key?("users")
    assert body.key?("meta")
    assert_equal 2, body["users"].length
    assert body["meta"]["total_count"] >= 2
    statuses = body["users"].map { |u| u["status"] }
    assert statuses.all? { |s| s == "active" }
  end

  test "GET /api/admin/users includes deactivated users when include_deactivated param is set" do
    get "/api/admin/users", params: { include_deactivated: true }, headers: @admin_headers
    assert_response :ok
    body = JSON.parse(response.body)
    assert_equal 3, body["users"].length
    assert body["meta"]["total_count"] >= 3
  end

  test "GET /api/admin/users returns users with correct fields" do
    get "/api/admin/users", headers: @admin_headers
    assert_response :ok
    body = JSON.parse(response.body)
    user = body["users"].find { |u| u["id"] == @user1.id }
    assert_equal "Alice Smith", user["name"]
    assert_equal "alice@example.com", user["email"]
    assert_equal "active", user["status"]
    assert user["subscribed_at"].present?
    assert user["created_at"].present?
  end

  test "GET /api/admin/users supports sorting by name ascending" do
    get "/api/admin/users", params: { sort: "name", direction: "asc" }, headers: @admin_headers
    assert_response :ok
    body = JSON.parse(response.body)
    names = body["users"].map { |u| u["name"] }
    assert_equal names, names.sort
  end

  test "GET /api/admin/users supports sorting by email descending" do
    get "/api/admin/users", params: { sort: "email", direction: "desc" }, headers: @admin_headers
    assert_response :ok
    body = JSON.parse(response.body)
    emails = body["users"].map { |u| u["email"] }
    assert_equal emails, emails.sort.reverse
  end

  test "GET /api/admin/users supports sorting by created_at" do
    get "/api/admin/users", params: { sort: "created_at", direction: "asc" }, headers: @admin_headers
    assert_response :ok
    body = JSON.parse(response.body)
    times = body["users"].map { |u| u["created_at"] }
    assert_equal times, times.sort
  end

  # Show tests
  test "GET /api/admin/users/:id returns user details" do
    get "/api/admin/users/#{@user1.id}", headers: @admin_headers
    assert_response :ok
    body = JSON.parse(response.body)
    assert_equal "Alice Smith", body["user"]["name"]
    assert_equal "alice@example.com", body["user"]["email"]
  end

  test "GET /api/admin/users/:id returns 404 for non-existent user" do
    get "/api/admin/users/99999", headers: @admin_headers
    assert_response :not_found
    body = JSON.parse(response.body)
    assert_equal "User not found", body["error"]
  end

  # Update tests
  test "PATCH /api/admin/users/:id updates user details" do
    patch "/api/admin/users/#{@user1.id}",
          params: { name: "Alice Updated", email: "alice.updated@example.com" }.to_json,
          headers: @admin_headers
    assert_response :ok
    body = JSON.parse(response.body)
    assert_equal "Alice Updated", body["user"]["name"]
    assert_equal "alice.updated@example.com", body["user"]["email"]
  end

  test "PATCH /api/admin/users/:id returns errors for invalid update" do
    patch "/api/admin/users/#{@user1.id}",
          params: { email: "" }.to_json,
          headers: @admin_headers
    assert_response :unprocessable_entity
    body = JSON.parse(response.body)
    assert body.key?("errors")
  end

  # Destroy (soft-delete) tests
  test "DELETE /api/admin/users/:id deactivates user" do
    delete "/api/admin/users/#{@user1.id}", headers: @admin_headers
    assert_response :ok
    body = JSON.parse(response.body)
    assert_equal "deactivated", body["user"]["status"]
    assert_equal "User deactivated", body["message"]

    # Verify the record still exists but is deactivated
    @user1.reload
    assert @user1.deactivated?
  end

  test "DELETE /api/admin/users/:id returns 403 without auth" do
    delete "/api/admin/users/#{@user1.id}"
    assert_response :forbidden
  end
end