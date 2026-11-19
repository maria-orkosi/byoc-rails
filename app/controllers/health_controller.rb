class HealthController < ActionController::API
  def show
    ActiveRecord::Base.connection.execute("select 1")
    render json: { ok: true }
  end
end
