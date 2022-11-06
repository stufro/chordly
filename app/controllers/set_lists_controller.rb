class SetListsController < ApplicationController
  def show
    @set_list = SetList.find(params[:id])
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

  private

  def set_list_params
    params.require(:set_list).permit(:name)
  end
end
