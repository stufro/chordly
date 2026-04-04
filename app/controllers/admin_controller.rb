class AdminController < Admin::BaseController
  def index
    @chord_sheets = ChordSheet.all
    @set_lists = SetList.all
    @users = User.where.not(id: current_user.id)
    @support_toast_stats = User.support_toast_stats(except: current_user)
  end
end
