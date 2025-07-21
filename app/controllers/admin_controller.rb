class AdminController < ApplicationController
  before_action :authorize_admin

  def index
    @chord_sheets = ChordSheet.all
    @set_lists = SetList.all
    @users = User.where.not(id: current_user.id)
  end
end
