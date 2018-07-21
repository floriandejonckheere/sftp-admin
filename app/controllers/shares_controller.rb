# frozen_string_literal: true

class SharesController < ApplicationController
  def index
    @shares = Share.all
  end

  def create
    @share = Share.new share_params

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
    @share = Share.find params[:id]
  end

  def edit
    @share = Share.find params[:id]
  end

  def update
    @share = Share.find params[:id]

    if @share.update share_params
      redirect_to @share
    else
      render 'edit'
    end
  end

  def destroy
    @share = Share.find params[:id]
    @share.destroy

    redirect_to shares_path
  end

  # TODO: async these methods
  def recalculate_usage
    @share = Share.find params[:share_id]

    Rails.logger.info "Recalculating disk usage for share #{@share.name}"
    @share.recalculate_usage

    redirect_to @share
  end

  # TODO: recalculate total storage directory
  def recalculate_all_usage
    Rails.logger.info "Recalculating disk usage for #{Share.count} share(s)"
    Share.all.each &:recalculate_usage!

    redirect :back
  end

  private

  def share_params
    if Rails.application.config.sftp['features']['quotas']
      params.require(:share).permit :name,
                                    :path,
                                    :quota
    else
      params.require(:share).permit :name,
                                    :path
    end
  end
end
