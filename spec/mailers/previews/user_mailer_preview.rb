# frozen_string_literal: true

class UserMailerPreview < ActionMailer::Preview
  def confirmation_instructions
    Devise::Mailer.confirmation_instructions(User.first, Devise.friendly_token)
  end

  def reset_password_instructions
    Devise::Mailer.reset_password_instructions(User.first, Devise.friendly_token)
  end

  def email_changed
    Devise::Mailer.email_changed(User.first)
  end

  def password_changed
    Devise::Mailer.password_change(User.first)
  end
end
