module Admin
  class UsersController < BaseController
    def show
      @user = User.find(params[:id])
    end
  end
end
