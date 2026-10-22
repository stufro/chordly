class ChordSheetVersionsController < ApplicationController
  before_action :authorize_user

  def index; end

  # Restores the chord sheet to this version
  def update
    @chord_sheet.versions.find(params.expect(:id)).reify.save
    redirect_to @chord_sheet
  end

  private

  def authorize_user
    @chord_sheet = ChordSheet.find(params.expect(:chord_sheet_id))
    authorize(@chord_sheet)
  end
end
