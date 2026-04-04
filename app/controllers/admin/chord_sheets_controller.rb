module Admin
  class ChordSheetsController < BaseController
    def show
      @chord_sheet = ChordSheet.find(params[:id])
    end
  end
end
