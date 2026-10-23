module Admin
  class ChordSheetsController < BaseController
    def index
      @chord_sheets = paginate(ChordSheet.includes(:user, :line_styles).order(created_at: :desc, id: :desc))
    end

    def show
      @chord_sheet = ChordSheet.find(params.expect(:id))
    end
  end
end
