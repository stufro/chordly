class NewslettersController < ApplicationController
  before_action :authorize_admin

  # Stay comfortably under the SES account send rate (14/sec), leaving room
  # for other mail the app sends concurrently.
  SEND_RATE_PER_SECOND = 10

  def new; end

  def create
    if params[:preview]
      send_email(current_user)
      render :new
    else
      users.each_slice(SEND_RATE_PER_SECOND).with_index do |batch, index|
        batch.each { |user| send_email(user, wait: index.seconds) }
      end
      redirect_to new_newsletter_path, notice: "Newsletter sent"
    end
  end

  private

  def send_email(user, wait: 0.seconds)
    return unless user.email?

    NewsletterMailer.with(
      subject: newsletter_params[:subject],
      content: newsletter_params[:content],
      email: user.email,
      user_uuid: user.uuid
    ).newsletter.deliver_later(wait:)
  end

  def users
    User.where(receive_emails: true)
  end

  def newsletter_params
    params.expect(newsletter: %i[subject content])
  end
end
