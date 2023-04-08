class BinController < ApplicationController
  def index
    @chord_sheets = current_user.chord_sheets.deleted.order(updated_at: :desc)
    @set_lists = current_user.set_lists.deleted.order(updated_at: :desc)
  end

  def update
    @resource = ChordSheet.find(params[:resource_id]).update(deleted: false)
    redirect_to bin_index_path, notice: "Chord Sheet restored"
  end
end
