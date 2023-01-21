class NewslettersController < ApplicationController
  before_action :authorize_admin

  def new; end

  def create
    NewsletterMailer.with(mailer_params).newsletter.deliver_later
    if params[:preview]
      render :new
    else
      redirect_to new_newsletter_path, notice: "Newsletter sent"
    end
  end

  private

  def mailer_params
    { subject: newsletter_params[:subject], content: newsletter_params[:content] }.tap do |p|
      p[:user] = current_user if params[:preview]
    end
  end

  def newsletter_params
    params.require(:newsletter).permit(:subject, :content)
  end
end
