class SessionsController < ApplicationController
  def new
    render json: { message: "Login page" }
  end

  def create
    # Dev login: only allowed when explicitly enabled via config flag or development mode.
    unless dev_login_allowed?
      redirect_to login_path, alert: "Dev login is not available in this environment."
      return
    end

    email = params[:email]
    if email.present?
      user = User.find_by(email: email)
      if user
        session[:user_id] = user.id
        redirect_to "/", notice: "Logged in as #{user.email}"
      else
        redirect_to login_path, alert: "No user found with that email."
      end
    else
      redirect_to login_path, alert: "Please provide an email."
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