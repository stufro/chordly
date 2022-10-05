class ChordSheetsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[transpose update]
  before_action :authorize_user, only: %i[show transpose update]

  def index
    current_user.chord_sheets << ChordSheet.find_by(id: session[:trial_id]) if session[:trial_id]

    @chord_sheets = ChordSheet.for_user(current_user).order(build_order_query)
  end

  def new
    @chord_sheet = ChordSheet.new
  end

  def create
    params[:chord_sheet][:content] = params[:chord_sheet][:content].gsub("\n", "\r\n")
    @chord_sheet = ChordSheet.new(chord_sheet_params)
    if @chord_sheet.save
      redirect_to @chord_sheet
    else
      flash.now[:alert] = "Something went wrong creating your chord sheet, if this persists " \
                          "please contact support"
      respond_to { |format| format.turbo_stream }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.pdf do
        html = render_to_string(layout: "application")
        send_data Grover.new(html).to_pdf, filename: "#{@chord_sheet.name}.pdf", type: "application/pdf"
      end
    end
  end

  def transpose
    @chord_sheet.transpose(params[:direction]).save
  end

  def update
    if @chord_sheet.update(chord_sheet_params)
      flash.now[:notice] = "Changes saved"
    else
      flash.now[:alert] = "Failed to update chord sheet"
    end
  end

  private

  def chord_sheet_params
    params.require(:chord_sheet).permit(:name, :content).tap do |p|
      p[:content] = ChordSheetModeller.new(p[:content]).parse if p[:content]
      p[:user] = current_user
    end
  end

  def build_order_query
    return { created_at: :desc } unless params[:order]

    { name: params[:order] }
  end

  def authorize_user
    @chord_sheet = ChordSheet.find(params[:id])
    authorize(@chord_sheet)
  end
end
