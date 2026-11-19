require "test_helper"

class BookingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @booking = Booking.create!(guest: "Alice", night: "2026-12-01", email: "alice@example.com")
  end

  test "should get index" do
    get bookings_url
    assert_response :success
    body = response.parsed_body
    assert_kind_of Array, body
    assert_equal 1, body.length
  end

  test "should show booking" do
    get booking_url(@booking)
    assert_response :success
    body = response.parsed_body
    assert_equal @booking.id, body["id"]
    assert_equal "Alice", body["guest"]
  end

  test "should create booking" do
    assert_difference("Booking.count", 1) do
      post bookings_url, params: { guest: "Bob", night: "2026-12-15", email: "bob@example.com" },
        headers: { "Content-Type" => "application/json" }, as: :json
    end
    assert_response :created
    body = response.parsed_body
    assert_equal "Bob", body["guest"]
    assert_equal "2026-12-15", body["night"]
    assert_equal "bob@example.com", body["email"]
  end

  test "should update booking" do
    patch booking_url(@booking), params: { guest: "Alice Updated" },
      headers: { "Content-Type" => "application/json" }, as: :json
    assert_response :success
    @booking.reload
    assert_equal "Alice Updated", @booking.guest
  end

  test "should destroy booking" do
    assert_difference("Booking.count", -1) do
      delete booking_url(@booking)
    end
    assert_response :no_content
  end

  test "should reject invalid email format" do
    post bookings_url, params: { guest: "Bad", night: "2026-12-01", email: "not-an-email" },
      headers: { "Content-Type" => "application/json" }, as: :json
    assert_response :unprocessable_entity
  end

  test "should get index under api scope" do
    get api_bookings_url
    assert_response :success
  end

  test "should show booking under api scope" do
    get api_booking_url(@booking)
    assert_response :success
  end
end