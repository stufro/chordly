class NewsletterMailer < ApplicationMailer
  def newsletter
    @content = params[:content]
    @user_uuid = params[:user_uuid]

    mail(to: params[:email], subject: params[:subject])
  end
end
