class ComponentsController < ApplicationController
  before_action :require_api_login

  def index
    components = Component.all.order(:id)
    render json: components.as_json(only: [:id, :name, :status, :last_deployed_at, :created_at])
  end

  private

  def require_api_login
    return if logged_in?

    render json: { error: "Unauthorized" }, status: :unauthorized
  end
end