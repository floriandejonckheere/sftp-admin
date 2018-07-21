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
end
