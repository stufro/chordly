class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  def after_sign_in_path_for(_resource)
    chord_sheets_path
  end

  def authorize(resource)
    return if resource.user_id == current_user.id

    redirect_to "/", alert: "You are not authorized to view this #{resource.class.name.underscore.titleize}"
  end
end
