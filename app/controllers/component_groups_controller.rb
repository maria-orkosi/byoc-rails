class ComponentGroupsController < ApplicationController
  before_action :set_project

  def create
    @group = @project.component_groups.create!(group_params)
    respond_to do |format|
      format.json { render json: { id: @group.id, name: @group.name } }
      format.html { redirect_to @project, notice: "Group created." }
    end
  end

  def update
    @group = @project.component_groups.find(params[:id])
    @group.update!(group_params)
    respond_to do |format|
      format.json { render json: { id: @group.id, name: @group.name } }
      format.html { redirect_to @project, notice: "Group updated." }
    end
  end

  def destroy
    @group = @project.component_groups.find(params[:id])
    @group.destroy!
    respond_to do |format|
      format.json { render json: { id: params[:id] } }
      format.html { redirect_to @project, notice: "Group deleted." }
    end
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def group_params
    params.permit(:name)
  end
end