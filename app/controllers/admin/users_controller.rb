module Admin
  class UsersController < BaseController
    def index
      @users = paginate(User.where.not(id: current_user.id).order(current_sign_in_at: :desc, id: :desc))
    end

    def show
      @user = User.find(params.expect(:id))
    end
  end
end
