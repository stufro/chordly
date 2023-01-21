class NewsletterMailer < ApplicationMailer
  def newsletter
    @content = params[:content]
    mail(bcc: users, subject: params[:subject])
  end

  private

  def users
    return [params[:user].email] if params[:user]

    User.where(receive_emails: true).map(&:email).compact
  end
end
