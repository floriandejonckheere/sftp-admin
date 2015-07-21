require 'ssh-fingerprint'

class PubKeysController < ApplicationController

  def create
    @user = User.find(params[:user_id])
    if @user.pub_keys.create(pubkey_params, :fingerprint => SSHFingerprint.compute(params[:key]))
      redirect_to @user
    else
      render 'new'
    end
  end

  def new
    @user = User.find(params[:user_id])
    @pubkey = PubKey.new
  end

  def edit
    @pubkey = PubKey.find(params[:pubkey_id])
  end

  def update
    @user = User.find(params[:user_id])
    @pubkey = PubKey.find(params[:pubkey_id])

    if @pubkey.update(pubkey_params, :fingerprint => SSHFingerprint.compute(params[:key]))
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:user_id])
    @pubkey = PubKey.find(params[:pubkey_id])
    @pubkey.destroy

    redirect_to @user
  end


  private
  def pubkey_params
    params.require(:pubkey).permit(:key)
  end

end
