class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(_resource)
    chord_sheets_path
  end

  def authorize(resource)
    return if trial_user_owns_resource?(resource)
    return if user_owns_resource?(resource)

    redirect_to "/", alert: "You are not authorized to view this #{resource.class.name.underscore.titleize}", code: 401
  end

  def authorize_admin
    return if current_user.admin?

    redirect_to "/", alert: "You are not authorized to view this page"
  end

  private

  def trial_user_owns_resource?(resource)
    current_user.nil? && (resource.trial? && resource.trial_user_id == session[:trial_user_id])
  end

  def user_owns_resource?(resource)
    current_user && resource.user_id == current_user.id
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(
      :account_update, keys: %i[username password password_confirmation current_password receive_emails]
    )
  end
end
