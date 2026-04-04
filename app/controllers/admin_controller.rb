class AdminController < ApplicationController
  before_action :authorize_admin

  def index
    @chord_sheets = ChordSheet.all
    @set_lists = SetList.all
    @users = User.where.not(id: current_user.id)
    @support_toast_eligible_count = @users.select(&:show_support_toast?).count
    @support_toast_seen_count = @users.where.not(support_toast_shown_at: nil).count
    @support_toast_dismissed_count = @users.where.not(support_toast_dismissed_at: nil).count
    @support_toast_clicked_count = @users.where.not(support_toast_clicked_at: nil).count
    @support_toast_clicked_users = @users.where.not(support_toast_clicked_at: nil).order(support_toast_clicked_at: :desc)
  end
end
