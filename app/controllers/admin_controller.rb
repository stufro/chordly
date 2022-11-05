class AdminController < ApplicationController
  before_action :authorize_admin

  def index
    @chord_sheets = ChordSheet.all
    @users = User.all
  end

  private

  def authorize_admin
    return if current_user.admin?

    redirect_to "/", alert: "You are not authorized to view this page"
  end
end
