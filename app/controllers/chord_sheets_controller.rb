# frozen_string_literal: true

class ChordSheetsController < ApplicationController
  def new
    @chord_sheet = ChordSheet.new
  end

  def create
    @chord_sheet = ChordSheet.new(chord_sheet_params)
    if @chord_sheet.save
      redirect_to @chord_sheet
    else
      render :new
    end
  end

  def show
    @chord_sheet = ChordSheet.find(params[:id])
  end

  private

  def chord_sheet_params
    params.require(:chord_sheet).permit(:name, :content)
  end
end
