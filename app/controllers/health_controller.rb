class HealthController < ActionController::API
  skip_before_action :verify_authenticity_token, raise: false

  # /up — lightweight DB-only liveness check (used by load balancers / k8s probes).
  # Does NOT check Redis so it remains fast and independent of optional services.
  def up
    db_status = check_database

    render json: {
      status: db_status,
      uptime: compute_uptime,
      checks: { db: db_status },
      timestamp: Time.now.iso8601
    }, status: db_status == "ok" ? :ok : :service_unavailable
  end

  # /health — full dependency health check (DB + Redis).
  def show
    checks = {
      db: check_database,
      redis: check_redis
    }

    overall_status = checks.values.all? { |v| v == "ok" } ? "ok" : "error"
    http_status = overall_status == "ok" ? :ok : :service_unavailable

    render json: {
      status: overall_status,
      uptime: compute_uptime,
      checks: checks,
      timestamp: Time.now.iso8601
    }, status: http_status
  end

  private

  def compute_uptime
    start_time = defined?($START_TIME) ? $START_TIME : Time.now
    (Time.now - start_time).round(2)
  end

  def check_database
    ActiveRecord::Base.connection.active? ? "ok" : "error"
  rescue StandardError
    "error"
  end

  def check_redis
    redis_url = ENV["REDIS_URL"] || "redis://localhost:6379"
    redis = Redis.new(url: redis_url, timeout: 0.5)
    redis.ping ? "ok" : "error"
  rescue StandardError
    "error"
  end
end
