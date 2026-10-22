class ChordSheetStylesController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :authorize_user

  # Resets the chord sheet to the built-in styles
  def destroy
    @chord_sheet.reset_styles
    flash.now[:notice] = "Styles reset"
    render "chord_sheets/update"
  end

  private

  def authorize_user
    @chord_sheet = ChordSheet.find(params.expect(:chord_sheet_id))
    authorize(@chord_sheet)
  end
end
