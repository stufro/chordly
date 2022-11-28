class SetListsController < ApplicationController
  def show
    @set_list = SetList.find(params[:id])
    @available_chord_sheets = current_user.chord_sheets - @set_list.chord_sheets
    @set_list_chord_sheets = @set_list.chord_sheets.order("chord_sheets_set_lists.position")
  end

  def new
    @set_list = SetList.new
  end

  def create
    @set_list = SetList.new(set_list_params)
    if @set_list.save
      redirect_to set_list_path(@set_list)
    else
      render :new
    end
  end

  def update
    @set_list = SetList.find(params[:id])
    if @set_list.update(set_list_params)
      flash.now[:notice] = "Changes saved"
    else
      flash.now[:alert] = "Failed to update set list: #{@set_list.errors.full_messages.join(', ')}"
    end
  end

  def destroy
    @set_list = SetList.find(params[:id])
    @set_list.update(deleted: true)
    flash[:notice] = "Set list deleted"
    redirect_to chord_sheets_path
  end

  def add_chord_sheet
    set_list = SetList.find(params[:id])
    chord_sheet = ChordSheet.find(params[:chord_sheet_id])
    ChordSheetsSetList.create(chord_sheet:, set_list:, position: set_list.next_position)

    redirect_to(set_list)
  end

  def remove_chord_sheet
    set_list = SetList.find(params[:id])
    set_list.chord_sheets.delete(params[:chord_sheet_id])
    set_list.refresh_positions

    redirect_to(set_list)
  end

  def reorder
    params[:new_order].split(",").each_with_index do |id, index|
      ChordSheetsSetList.find(id).update(position: index + 1)
    end
  end

  private

  def set_list_params
    params.require(:set_list).permit(:name).tap do |p|
      p[:user] = current_user
    end
  end
end
