class SharesController < ApplicationController

  def index
    @shares = Share.all
  end

  def create
    @share = Share.new(share_params)
    if @share.save
      redirect_to @share
    else
      render 'new'
    end
  end

  def new
    @share = Share.new
  end

  def show
    @share = Share.find(params[:id])
  end

  def edit
    @share = Share.find(params[:id])
  end

  def update
    @share = Share.find(params[:id])

    if @share.update(share_params)
      redirect_to @share
    else
      render 'edit'
    end
  end

  def destroy
    @share = Share.find(params[:id])
    @share.destroy

    redirect_to shares_path
  end


  private
  def share_params
    params.require(:share).permit(:name, :path, :quotum)
  end

end
