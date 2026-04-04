class RegistrationsController < Devise::RegistrationsController
  prepend_before_action :check_captcha, only: [:create] # rubocop:disable Rails/LexicallyScopedActionFilter

  def update_theme
    current_user.update(theme: params[:theme]) if params[:theme].in?(%w[light dark])
    head :ok
  end

  def update_support_toast
    return head(:unauthorized) unless user_signed_in?

    current_user.record_support_toast_action(params[:action_type])
    head :ok
  end

  private

  def check_captcha
    return if verify_recaptcha

    self.resource = resource_class.new sign_up_params
    resource.validate
    set_minimum_password_length

    respond_with_navigational(resource) do
      flash.discard(:recaptcha_error)
      render :new
    end
  end
end
