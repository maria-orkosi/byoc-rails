class ApplicationController < ActionController::Base
  include ActionController::Helpers

  before_action :set_current_user

  helper_method :current_user, :user_signed_in?

  private

  def set_current_user
    @current_user = User.first || User.create!(email: "default@byoc-rails.dev")
  end

  def current_user
    @current_user
  end

  def user_signed_in?
    current_user.present?
  end
end