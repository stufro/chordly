class AdminController < ApplicationController
  before_action :authorize_admin

  def index
    @chord_sheets = ChordSheet.all
    @set_lists = SetList.all
    @users = User.all
  end
end
