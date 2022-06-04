# frozen_string_literal: true

class ChordSheetsController < ApplicationController
  def index
    @chord_sheets = ChordSheet.order(updated_at: :desc)
  end

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

  def transpose
    @chord_sheet = ChordSheet.find(params[:chord_sheet_id])
    @chord_sheet.transpose(params[:direction]).save
    redirect_to @chord_sheet
  end

  def update
    @chord_sheet = ChordSheet.find(params[:id])
    if @chord_sheet.update(chord_sheet_params)
      flash.now[:notice] = "Saved changes"
    else
      flash.now[:alert] = "Failed to update chord sheet"
    end
  end

  private

  def chord_sheet_params
    params.require(:chord_sheet).permit(:name, :content).tap do |p|
      p[:content] = ChordSheetModeller.new(p[:content]).parse if p[:content]
    end
  end
end
