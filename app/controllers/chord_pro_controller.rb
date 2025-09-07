class ChordProController < ApplicationController
  def new
    @chord_sheet = ChordSheet.new
  end

  def create
    @chord_sheet = ChordSheet.new(chord_sheet_params)
    if @chord_sheet.save
      redirect_to @chord_sheet
    else
      flash.now[:alert] = "Failed to create chord sheet: #{@chord_sheet.errors.full_messages.join(', ')}"
      respond_to do |format|
        format.turbo_stream { render "chord_sheets/create" }
      end
    end
  end

  private

  def chord_sheet_params
    params.require(:chord_sheet).permit(:name, :content, :trial, :trial_user_id).tap do |p|
      if p[:content]
        chord_pro_parsed = ChordProConverter.new(p[:content])
        p[:content] = ChordSheetModeller.new(chord_pro_parsed.body).parse
        p[:name] = chord_pro_parsed.title
      end

      p[:created_from_chord_pro] = true
      p[:user] = current_user
    end
  end
end
