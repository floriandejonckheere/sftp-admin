# frozen_string_literal: true

class ApiController < ApplicationController
  def show_user
    @user = User.find params[:id]
  end

  def show_share
    @share = Share.find_by :path => params[:path]
  end
end
