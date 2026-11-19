class OnboardingController < ApplicationController
  TOTAL_STEPS = 4

  def show
    if current_user.has_projects? || current_user.onboarding_completed?
      respond_to do |format|
        format.html { redirect_to projects_path }
        format.json { render json: { redirect_to: projects_path } }
      end
      return
    end

    @step = (params[:step] || current_user.onboarding_step || 1).to_i
    @step = [[@step, 1].max, TOTAL_STEPS].min
    @onboarding_data = session[:onboarding_data] || {}

    respond_to do |format|
      format.html { render :show }
      format.json { render json: { step: @step, onboarding_data: @onboarding_data, has_projects: current_user.has_projects? } }
    end
  end

  def update
    if current_user.has_projects? || current_user.onboarding_completed?
      respond_to do |format|
        format.html { redirect_to projects_path }
        format.json { render json: { redirect_to: projects_path } }
      end
      return
    end

    @step = (params[:step] || 1).to_i
    @onboarding_data = session[:onboarding_data] || {}
    @onboarding_data = @onboarding_data.merge(onboarding_params)

    if params[:direction] == "back"
      @step = [@step - 1, 1].max
      session[:onboarding_data] = @onboarding_data
      current_user.update!(onboarding_step: @step)
      respond_to do |format|
        format.html { redirect_to onboarding_path(step: @step) }
        format.json { render json: { step: @step, onboarding_data: @onboarding_data } }
      end
      return
    end

    unless valid_step?(@step, @onboarding_data)
      @errors = validate_step(@step, @onboarding_data)
      session[:onboarding_data] = @onboarding_data
      respond_to do |format|
        format.html do
          flash.now[:alert] = "Please fix the errors below."
          render :show
        end
        format.json { render json: { errors: @errors, step: @step, onboarding_data: @onboarding_data }, status: :unprocessable_entity }
      end
      return
    end

    session[:onboarding_data] = @onboarding_data
    current_user.update!(onboarding_step: @step)

    if @step < TOTAL_STEPS
      next_step = @step + 1
      current_user.update!(onboarding_step: next_step)
      respond_to do |format|
        format.html { redirect_to onboarding_path(step: next_step) }
        format.json { render json: { next_step: next_step, step: @step, onboarding_data: @onboarding_data } }
      end
    else
      project = ProjectGenerator.new(current_user, @onboarding_data).call
      session.delete(:onboarding_data)
      current_user.update!(onboarding_completed: true, onboarding_step: 0)
      respond_to do |format|
        format.html { redirect_to project_path(project) }
        format.json { render json: { redirect_to: project_path(project), project: project } }
      end
    end
  end

  private

  def onboarding_params
    permitted = {}
    permitted[:project_name] = params[:project_name] if params[:project_name].present?
    permitted[:database_choice] = params[:database_choice] if params[:database_choice].present?
    permitted[:gems] = params[:gems] if params[:gems].present?
    permitted[:commit_message] = params[:commit_message] if params[:commit_message].present?
    permitted
  end

  def valid_step?(step, data)
    validate_step(step, data).empty?
  end

  def validate_step(step, data)
    errors = {}
    case step
    when 1
      errors[:project_name] = "Project name is required" if data[:project_name].blank?
    when 2
      errors[:database_choice] = "Please select a database" if data[:database_choice].blank?
    when 3
      # Optional gems step - always valid
    when 4
      errors[:commit_message] = "Commit message is required" if data[:commit_message].blank?
    end
    errors
  end
end