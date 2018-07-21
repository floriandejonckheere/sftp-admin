# frozen_string_literal: true

require 'key_manager'

class KeysController < ApplicationController
  def create
    @user = User.find params[:user_id]

    params = key_params
    params[:key].chomp!

    @key = @user.keys.new params

    if @key.save
      redirect_to @user
    else
      render 'new'
    end
  end

  def new
    @user = User.find params[:user_id]
    @key = Key.new
  end

  def edit
    @key = Key.find params[:id]
  end

  def update
    @user = User.find params[:user_id]
    @key = Key.find params[:id]

    if @key.update key_params
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find params[:user_id]
    @key = Key.find params[:id]
    @key.destroy

    redirect_to @user
  end

  private

  def key_params
    params.require(:key).permit :title,
                                :key
  end
end
