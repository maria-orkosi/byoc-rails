class Rack::Attack
  # Throttle waiting list submissions: 5 requests per IP per 1 hour
  waiting_list_limit = (ENV["WAITING_LIST_RATE_LIMIT"] || "5").to_i
  waiting_list_period = (ENV["WAITING_LIST_RATE_PERIOD"] || "3600").to_i

  throttle("waiting_list/ip", limit: waiting_list_limit, period: waiting_list_period) do |req|
    if req.post? && (req.path == "/waiting_list" || req.path == "/api/waiting_list")
      req.ip
    end
  end
end

# Custom 429 response for rate-limited requests
Rack::Attack.throttled_responder = lambda do |request|
  body = { message: "Rate limit exceeded. Please try again later." }.to_json

  [429, { "Content-Type" => "application/json" }, [body]]
end