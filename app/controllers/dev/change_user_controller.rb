module Dev
  class ChangeUserController < ApplicationController
    skip_before_action :authenticate_user!

    def index
      user = User.find_by(email:)
      sign_in(user) if user
      flash = user ? {} : { alert: "No user found with email: #{email || 'no email given'}" }
      redirect_to authenticated_root_path, flash
    end

    private

    def email
      params[:email].presence
    end
  end
end
