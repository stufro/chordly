class UnsubscribeController < ApplicationController
  skip_before_action :authenticate_user!

  def show
    @user = User.find_by(uuid: params[:token])
    return unless @user

    @user.update(receive_emails: false)
  end
end
