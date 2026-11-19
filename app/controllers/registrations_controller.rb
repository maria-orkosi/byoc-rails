require "net/http"
require "uri"

class RegistrationsController < ActionController::API
  # POST /api/registrations
  # Creates a user account and fires an analytics conversion event.
  # No PII (emails, names) is sent to the analytics service — only
  # an anonymized user ID.
  def create
    user_id = SecureRandom.uuid

    if Rails.application.config.analytics_enabled && Rails.application.config.analytics_key.present?
      track_conversion(user_id)
    end

    render json: { id: user_id, message: "Registration successful" }, status: :created
  end

  private

  def track_conversion(user_id)
    endpoint = Rails.application.config.analytics_endpoint.to_s
    return if endpoint.empty?

    # Fire-and-forget: do not block the response on analytics delivery.
    Thread.new do
      begin
        uri = URI(endpoint)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = uri.scheme == "https"
        http.open_timeout = 2
        http.read_timeout = 2

        req = Net::HTTP::Post.new(uri.path.empty? ? "/" : uri.path, { "Content-Type" => "application/json" })
        req.body = {
          key:    ENV["ANALYTICS_KEY"],
          event:  "signup_conversion",
          userId: user_id
        }.to_json

        http.request(req)
      rescue StandardError
        # Analytics delivery failures must never affect the user response.
      end
    end
  end
end