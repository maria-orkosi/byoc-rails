class ProjectComponentsController < ApplicationController
  before_action :set_project

  def create
    component = Component.find(params[:component_id])
    group_id = params[:component_group_id].presence
    max_pos = @project.project_components.maximum(:position) || -1
    @project_component = @project.project_components.create!(
      component: component,
      component_group_id: group_id,
      position: max_pos + 1
    )

    respond_to do |format|
      format.json do
        render json: {
          id: @project_component.id,
          component: {
            id: component.id,
            name: component.name,
            description: component.description,
            version: component.version,
            compatibility: component.compatibility
          },
          component_group_id: @project_component.component_group_id,
          group_name: @project_component.component_group&.name,
          position: @project_component.position,
          count: @project.project_components.count
        }
      end
      format.html { redirect_to @project, notice: "Component added." }
    end
  end

  def update
    @project_component = @project.project_components.find(params[:id])
    @project_component.update!(update_params)

    respond_to do |format|
      format.json do
        render json: {
          id: @project_component.id,
          component_group_id: @project_component.component_group_id,
          group_name: @project_component.component_group&.name
        }
      end
      format.html { redirect_to @project, notice: "Component updated." }
    end
  end

  def destroy
    @project_component = @project.project_components.find(params[:id])
    @project_component.destroy!

    respond_to do |format|
      format.json do
        render json: {
          id: params[:id],
          count: @project.project_components.count
        }
      end
      format.html { redirect_to @project, notice: "Component removed." }
    end
  end

  def reorder
    positions = params[:positions]
    positions.each do |item|
      @project.project_components.find(item[:id]).update!(position: item[:position])
    end

    respond_to do |format|
      format.json { render json: { ok: true } }
      format.html { redirect_to @project, notice: "Order updated." }
    end
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def update_params
    params.permit(:component_group_id, :position)
  end
end