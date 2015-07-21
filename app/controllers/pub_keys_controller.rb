require 'ssh-fingerprint'

class PubKeysController < ApplicationController

  def create
    @user = User.find(params[:user_id])

    parameters = pubkey_params
    parameters[:fingerprint] = SSHFingerprint.compute(params[:pub_key][:key])

    @pub_key = @user.pub_keys.new(parameters)

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

    if @pub_key.update(pubkey_params, :fingerprint => SSHFingerprint.compute(params[:key]))
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


  private
  def pubkey_params
    params.require(:pub_key).permit(:title, :key)
  end

end
