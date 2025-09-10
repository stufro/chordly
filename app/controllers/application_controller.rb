class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :initialize_schema_dot_com

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
    current_user.nil? && resource.trial? && resource.trial_user_id == session[:trial_user_id]
  end

  def user_owns_resource?(resource)
    current_user && resource.user_id == current_user.id
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(
      :account_update, keys: %i[username password password_confirmation current_password receive_emails]
    )
  end

  # rubocop:disable Metrics/MethodLength
  def initialize_schema_dot_com
    @organization_schema = SchemaDotOrg::Organization.new(
      name: "Chordly",
      founder: SchemaDotOrg::Person.new(name: "Stuart Frost"),
      email: "support@chordly.co.uk",
      url: "https://chordly.co.uk",
      founding_date: Date.new(2023, 10),
      founding_location: SchemaDotOrg::Place.new(address: "United Kingdom"),
      logo: "https://chordly.co.uk/favicons/favicon-96x96.png"
    )

    @website_schema = SchemaDotOrg::WebSite.new(
      name: "Chordly",
      url: "https://chordly.co.uk"
    )
  end
  # rubocop:enable Metrics/MethodLength
end
