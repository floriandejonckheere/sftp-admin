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

  # TODO: async these methods
  def usage
    @share = Share.find(params[:share_id])
    @share.usage

    redirect_to share_path(@share)
  end

  def usage_all
    SharesController.usage_all

    redirect_to shares_path
  end

  def self.usage_all
    Rails.application.config.logger.info "Recalculating disk usage for #{Share.count} shares"
    Share.all.each do |share|
      share.usage
    end
  end


  private
  def share_params
    params.require(:share).permit(:name, :path, :quota)
  end

end
