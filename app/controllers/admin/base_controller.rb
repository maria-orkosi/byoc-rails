module Admin
  class BaseController < ActionController::API
    before_action :authenticate_admin!

    private

    def authenticate_admin!
      admin_token = request.headers["X-Admin-Token"]
      expected_token = ENV.fetch("ADMIN_API_TOKEN")

      if expected_token.blank?
        render json: { error: "Forbidden" }, status: :forbidden
        return
      end

      unless admin_token.present? && ActiveSupport::SecurityUtils.secure_compare(admin_token, expected_token)
        render json: { error: "Unauthorized" }, status: :forbidden
      end
    end
  end
end