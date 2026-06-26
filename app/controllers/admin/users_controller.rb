module Admin
  class UsersController < BaseController
    def show
      @user = User.find(params.expect(:id))
    end
  end
end
