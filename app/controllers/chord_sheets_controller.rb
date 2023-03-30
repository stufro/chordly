class ChordSheetsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[create show transpose update]
  before_action :authorize_user, only: %i[show transpose update destroy versions]
  before_action :adjust_new_lines, only: %i[create]

  def index
    @chord_sheets = current_user.chord_sheets.not_deleted.order(build_order_query(:chord_sheet))
    @set_lists = current_user.set_lists.not_deleted.order(build_order_query(:set_list))
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

  def new
    @chord_sheet = ChordSheet.new
  end

  def create
    @chord_sheet = ChordSheet.new(chord_sheet_params)
    if @chord_sheet.save
      redirect_to @chord_sheet
    else
      flash.now[:alert] = "Failed to create chord sheet: #{@chord_sheet.errors.full_messages.join(', ')}"
      respond_to { |format| format.turbo_stream }
    end
  end

  def transpose
    @chord_sheet.transpose(params[:direction]).save
  end

  def update
    if @chord_sheet.update(chord_sheet_params)
      flash.now[:notice] = "Changes saved"
    else
      flash.now[:alert] = "Failed to update chord sheet: #{@chord_sheet.errors.full_messages.join(', ')}"
    end
  end

  def destroy
    @chord_sheet.update(deleted: true)
    flash[:notice] = "Chord sheet deleted"
    redirect_to chord_sheets_path
  end

  def versions; end

  private

  def chord_sheet_params
    params.require(:chord_sheet).permit(:name, :content, :trial, :trial_user_id).tap do |p|
      p[:content] = ChordSheetModeller.new(p[:content]).parse if p[:content]
      p[:user] = current_user
    end
  end

  def adjust_new_lines
    params[:chord_sheet][:content] = params[:chord_sheet][:content].gsub("\n", "\r\n")
  end

  def build_order_query(resource)
    return { created_at: :desc } unless params["#{resource}_order"]

    { name: params["#{resource}_order"] }
  end

  def authorize_user
    @chord_sheet = ChordSheet.find(params[:id])
    authorize(@chord_sheet)
  end
end
