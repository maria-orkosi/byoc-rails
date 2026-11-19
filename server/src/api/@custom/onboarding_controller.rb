class OnboardingController < ActionController::API
  # GET /api/onboarding
  def show
    state = OnboardingState.for_account(account_id).first

    if state.nil?
      render json: { status: "not_started", steps: OnboardingState::STEPS, current_step: nil, completed: false }
    else
      render json: {
        status: state.completed ? "completed" : "in_progress",
        steps: OnboardingState::STEPS,
        current_step: state.current_step,
        completed: state.completed,
        completed_at: state.completed_at
      }
    end
  end

  # POST /api/onboarding/start
  def start
    state = OnboardingState.start!(account_id: account_id)
    render json: {
      status: "in_progress",
      steps: OnboardingState::STEPS,
      current_step: state.current_step,
      completed: state.completed
    }, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  # POST /api/onboarding/advance
  def advance
    state = OnboardingState.for_account(account_id).first

    if state.nil?
      render json: { error: "Onboarding not started" }, status: :not_found
      return
    end

    state.advance!
    render json: {
      status: state.completed ? "completed" : "in_progress",
      steps: OnboardingState::STEPS,
      current_step: state.current_step,
      completed: state.completed,
      completed_at: state.completed_at
    }
  end

  # POST /api/onboarding/skip
  def skip
    state = OnboardingState.for_account(account_id).first

    if state.nil?
      render json: { error: "Onboarding not started" }, status: :not_found
      return
    end

    state.skip!
    render json: {
      status: "completed",
      steps: OnboardingState::STEPS,
      current_step: "complete",
      completed: true,
      completed_at: state.completed_at
    }
  end

  private

  def account_id
    @account_id ||= request.remote_ip
  end
end