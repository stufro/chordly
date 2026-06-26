module Admin
  class ChordSheetsController < BaseController
    def show
      @chord_sheet = ChordSheet.find(params.expect(:id))
    end
  end
end
