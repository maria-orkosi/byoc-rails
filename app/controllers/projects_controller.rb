class ProjectsController < ApplicationController
  def index
    @projects = current_user.projects.ordered

    unless current_user.has_projects? || current_user.onboarding_completed?
      respond_to do |format|
        format.html { redirect_to onboarding_path(step: 1) }
        format.json { render json: { redirect_to: onboarding_path(step: 1) } }
      end
      return
    end

    respond_to do |format|
      format.html { render :index }
      format.json { render json: @projects }
    end
  end

  def show
    @project = current_user.projects.find(params[:id])
    respond_to do |format|
      format.html { render :show }
      format.json { render json: @project }
    end
  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.html { redirect_to projects_path, alert: "Project not found." }
      format.json { render json: { error: "Project not found." }, status: :not_found }
    end
  end
end