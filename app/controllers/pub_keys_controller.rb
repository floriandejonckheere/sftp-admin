require 'key_manager'

class PubKeysController < ApplicationController

  def create
    @user = User.find(params[:user_id])

    params = pubkey_params
    params[:key] = params[:key].chomp

    @pub_key = @user.pub_keys.new(params)

    if @pub_key.save
      redirect_to @user
    else
      render 'new'
    end
  end

  def new
    @user = User.find(params[:user_id])
    @pub_key = PubKey.new
  end

  def edit
    @pub_key = PubKey.find(params[:id])
  end

  def update
    @user = User.find(params[:user_id])
    @pub_key = PubKey.find(params[:id])

    if @pub_key.update(pubkey_params)
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:user_id])
    @pub_key = PubKey.find(params[:id])
    @pub_key.destroy

    redirect_to @user
  end

  def self.regenerate_all
    KeyManager.regenerate_all
  end

  private
  def pubkey_params
    params.require(:pub_key).permit(:title, :key)
  end

end
