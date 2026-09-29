class RegistrationsController < Devise::RegistrationsController
  prepend_before_action :check_captcha, only: [:create] # rubocop:disable Rails/LexicallyScopedActionFilter
  rate_limit to: 5, within: 1.hour, only: :create, prepend: true, with: lambda {
    redirect_to new_user_registration_path, alert: "Too many sign up attempts. Please try again later."
  }

  def update_theme
    current_user.update(theme: params[:theme]) if params.expect(:theme).in?(%w[light dark])
    head :ok
  end

  def update_support_toast
    return head(:unauthorized) unless user_signed_in?

    current_user.record_support_toast_action(params[:action_type])
    head :ok
  end

  private

  def check_captcha
    return if verify_recaptcha(action: "signup", minimum_score: 0.4)

    self.resource = resource_class.new sign_up_params
    resource.validate
    set_minimum_password_length

    respond_with_navigational(resource) do
      flash.discard(:recaptcha_error)
      render :new, status: :unprocessable_content
    end
  end
end
