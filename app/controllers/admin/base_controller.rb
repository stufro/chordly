module Admin
  class BaseController < ApplicationController
    PER_PAGE = 50

    before_action :authorize_admin

    private

    def paginate(scope)
      @total_pages = [(scope.count / PER_PAGE.to_f).ceil, 1].max
      @page = params[:page].to_s.to_i.clamp(1, @total_pages)
      scope.limit(PER_PAGE).offset((@page - 1) * PER_PAGE)
    end
  end
end
