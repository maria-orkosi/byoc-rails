require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "GET /api/landing_page returns landing page data" do
    get "/api/landing_page"
    assert_response :ok
    body = JSON.parse(response.body)

    assert_equal "Byoc Rails", body["company_name"]
    assert_equal "Byoc Rails runs on Orkosi from its own code", body["tagline"]
    assert body["description"].present?
    assert_equal "saas", body["audience"]
    assert body.key?("features")
    assert body["features"].is_a?(Array)
    assert body["features"].length >= 3
  end

  test "GET /api/landing_page features have required keys" do
    get "/api/landing_page"
    assert_response :ok
    body = JSON.parse(response.body)

    body["features"].each do |feature|
      assert feature.key?("title")
      assert feature.key?("description")
      assert feature["title"].present?
      assert feature["description"].present?
    end
  end

  test "GET /api/landing_page does not require authentication" do
    get "/api/landing_page"
    assert_response :ok
  end
end