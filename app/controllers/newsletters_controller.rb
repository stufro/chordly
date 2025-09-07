class NewslettersController < ApplicationController
  before_action :authorize_admin

  def new; end

  def create
    if params[:preview]
      send_email(current_user)
      render :new
    else
      users.each { |user| send_email(user) }
      redirect_to new_newsletter_path, notice: "Newsletter sent"
    end
  end

  private

  def send_email(user)
    return unless user.email?

    NewsletterMailer.with(
      subject: newsletter_params[:subject],
      content: newsletter_params[:content],
      email: user.email,
      user_uuid: user.uuid
    ).newsletter.deliver_later
  end

  def users
    User.where(receive_emails: true)
  end

  def newsletter_params
    params.require(:newsletter).permit(:subject, :content)
  end
end
