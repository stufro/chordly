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
    params.require(:chord_sheet).permit(:name, :content, :file).tap do |p|
      chord_pro_parsed = parsed_content(p)
      if chord_pro_parsed.present?
        p[:content] = ChordSheetModeller.new(chord_pro_parsed.body).parse
        p[:name] = chord_pro_parsed.title
      end

      p[:created_from_chord_pro] = true
      p[:user] = current_user
    end
  end

  def parsed_content(parameters)
    if parameters[:file]
      file = parameters.delete(:file)
      ChordProConverter.new(file.read)
    elsif parameters[:content]
      ChordProConverter.new(parameters[:content])
    end
  end
end
