class ComponentsController < ActionController::API
  def index
    components = Component.all.order(:id)
    render json: components.as_json(only: [:id, :name, :status, :last_deployed_at, :created_at])
  end
end