Rails.application.routes.draw do
  
  root to: 'pages#home'
  ['help', 'contact', 'faq', 'about', 'terms'].each do |page|
    get "/#{page}", to: ("pages#" + "#{page}"), as: page 
  end

  resources :polls
  resources :services, only: [:index, :show]
  resources :events
  get '/invite_friends', to: 'events#invite_friends', as: 'invite_friends'

  get '/opentable', to: 'services#opentable', as: 'opentable'
  
  get '/s1', to: 'pages#screen_one'
  get '/s2', to: 'pages#screen_two'
  get '/appstore', to: 'pages#app_store'
  get '/dashboard', to: 'users#dashboard', as: 'dashboard'





  get '/auth/facebook/callback', :to => 'sessions#create'
  get '/auth/failure', :to => 'sessions#failure'
  get '/logout', :to => 'sessions#destroy'
end
