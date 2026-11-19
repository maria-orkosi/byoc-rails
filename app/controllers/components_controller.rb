class ComponentsController < ApplicationController
  def index
    @components = Component.search(params[:search])
                           .order(:name)
                           .page(params[:page])
                           .per(12)
  end

  def show
    @component = Component.find(params[:id])
    @projects = Project.order(:name)
  end
end