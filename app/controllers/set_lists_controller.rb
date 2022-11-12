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

  def update
    @set_list = SetList.find(params[:id])
    if @set_list.update(set_list_params)
      flash.now[:notice] = "Changes saved"
    else
      flash.now[:alert] = "Failed to update set list: #{@set_list.errors.full_messages.join(', ')}"
    end
  end

  private

  def set_list_params
    params.require(:set_list).permit(:name).tap do |p|
      p[:user] = current_user
    end
  end
end
