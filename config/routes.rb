# frozen_string_literal: true

Rails.application.routes.draw do
  root 'application#index'

  resources :shares do
    resource :usage,
             :only => :create,
             :controller => 'shares',
             :action => 'recalculate_usage'
  end

  resources :users do
    resources :keys, :except => %i[index show]
  end

  resource :usage,
           :only => :create,
           :controller => 'shares',
           :action => 'recalculate_all_usage'

  resource :dashboard, :only => :index

  scope :api, :format => :json do
    get '/users/:id' => 'api#show_user'
    get '/shares/:path' => 'api#show_share'
  end
end
