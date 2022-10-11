class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  def after_sign_in_path_for(_resource)
    chord_sheets_path
  end

  def authorize(resource)
    return if trial_user_owns_resource?(resource)
    return if user_owns_resource?(resource)

    redirect_to "/", alert: "You are not authorized to view this #{resource.class.name.underscore.titleize}", code: 401
  end

  private

  def trial_user_owns_resource?(resource)
    (current_user.nil? && (resource.trial? && resource.trial_user_id == session[:trial_user_id]))
  end

  def user_owns_resource?(resource)
    current_user && resource.user_id == current_user.id
  end
end
