class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :update, :destroy]

  def index
    @projects = Project.order(:name)
  end

  def show
    @project_components = @project.project_components
                                  .includes(:component, :component_group)
                                  .order(:position)
    @component_groups = @project.component_groups.order(:name)
    @available_components = Component.where.not(
      id: @project.component_ids
    ).order(:name)
  end

  def create
    @project = Project.create!(project_params)
    redirect_to @project, notice: "Project created."
  end

  def update
    @project.update!(project_params)
    redirect_to @project, notice: "Project updated."
  end

  def destroy
    @project.destroy!
    redirect_to projects_path, notice: "Project deleted."
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:name, :description)
  end
end