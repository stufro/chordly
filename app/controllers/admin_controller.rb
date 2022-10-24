class AdminController < ApplicationController
  def index
    @chord_sheets = ChordSheet.all
    @users = User.all
  end
end