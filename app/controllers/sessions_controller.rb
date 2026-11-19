class SessionsController < ApplicationController
  def new
  end

  def create
    # Dev login: only allowed when explicitly enabled via config flag or development mode.
    unless dev_login_allowed?
      redirect_to login_path, alert: "Dev login is not available in this environment."
      return
    end

    user_id = params[:user_id]
    if user_id.present?
      user = User.find_by(id: user_id) || User.create!(id: user_id, email: "dev-#{user_id}@example.com")
      session[:user_id] = user.id
      redirect_to dashboard_path, notice: "Logged in as user ##{user.id}"
    else
      redirect_to login_path, alert: "Please provide a user_id."
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path, notice: "Logged out."
  end

  private

  def dev_login_allowed?
    Rails.env.development? || ENV["ALLOW_DEV_LOGIN"] == "1"
  end
end