Rails.application.routes.draw do

  resources :shares do
    post 'usage' => 'shares#recalculate_usage'
  end
  resources :users do
    resources :pub_keys, :except => [:index, :show]
  end

  post '/usage' => 'shares#recalculate_all_usage'

  get '/dashboard' => 'dashboard#index'
  get '/statistics' => 'statistics#index'

  root 'dashboard#index'

end
