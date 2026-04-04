module Admin
  class BaseController < ApplicationController
    before_action :authorize_admin
  end
end
