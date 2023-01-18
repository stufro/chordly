class NewslettersController < ApplicationController
  before_action :authorize_admin

  def new; end

  def create
    if params[:preview]
      NewsletterMailer.with(subject: newsletter_params[:subject],
                            content: newsletter_params[:content],
                            user: current_user).newsletter.deliver_later
      render :new
    else
      NewsletterMailer.with(subject: newsletter_params[:subject],
                            content: newsletter_params[:content]).newsletter.deliver_later
      redirect_to new_newsletter_path, notice: "Newsletter sent"
    end
  end

  private

  def newsletter_params
    params.require(:newsletter).permit(:subject, :content)
  end
end
