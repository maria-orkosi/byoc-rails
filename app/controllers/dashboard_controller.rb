class DashboardController < ApplicationController
  before_action :require_login

  helper_method :component_status_class

  def index
    @components = Component.all.order(:id)
  end

  private

  def component_status_class(component)
    status = (component.status || "").downcase
    if %w[active ok running].include?(status)
      "active"
    elsif %w[inactive error stopped].include?(status)
      "inactive"
    else
      "unknown"
    end
  end
end