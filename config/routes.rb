Rails.application.routes.draw do

  resources :shares do
    post 'usage'
  end
  resources :users do
    resources :pub_keys, :except => [:index, :show]
  end

  get '/dashboard' => 'dashboard#index'
  post '/usage' => 'shares#recalculate_usage'
  get '/statistics' => 'statistics#index'

  root 'dashboard#index'

end
