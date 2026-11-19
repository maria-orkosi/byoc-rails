class SessionsController < ApplicationController
  def new
  end

  def create
    # Dev login: only allowed in development mode to prevent bypassing auth in production.
    unless Rails.env.development?
      redirect_to login_path, alert: "Dev login is only available in development."
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
end