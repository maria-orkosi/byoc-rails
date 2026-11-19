class ComponentsController < ApplicationController
  def index
    unless logged_in?
      render json: { error: "Unauthorized" }, status: :unauthorized
      return
    end

    components = Component.all.order(:id)
    render json: components.as_json(only: [:id, :name, :status, :last_deployed_at, :created_at])
  end
end