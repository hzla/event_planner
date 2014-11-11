Rails.application.routes.draw do
  
  root to: 'pages#home'
  ['help', 'contact', 'faq', 'about', 'terms'].each do |page|
    get "/#{page}", to: ("pages#" + "#{page}"), as: page 
  end

  
  resources :services, only: [:index, :show]
  resources :events
  get '/events/:id/activate', to: 'events#activate', as: 'activate'
  get '/events/:id/results', to: 'events#results', as: 'results'

  resources :polls 
  get '/polls/:id/take', to: 'polls#take', as: 'take'
  resources :choices

  get '/choices/:id/vote', to: 'choices#vote', as: 'vote'

  get '/invite_friends', to: 'events#invite_friends', as: 'invite_friends'

  get '/opentable', to: 'services#opentable', as: 'opentable'
  
  get '/s1', to: 'pages#screen_one'
  get '/s2', to: 'pages#screen_two'
  get '/appstore', to: 'pages#app_store'
  get '/dashboard', to: 'users#dashboard', as: 'dashboard'


  namespace :api, :defaults => {:format => :json} do
    namespace :v1 do
      resources :users
      post '/users/:id', to: 'users#update' 
      resources :events
      post '/events/:id', to: 'events#update'
      get '/events/search', to: 'events#search'
      resources :polls 
      resources :choices
      get '/choices/:id/vote', to: 'choices#vote'
      resources :services, only: [:index]

      ["users", "events", "polls", "choices"].each do |resource|
        delete "/#{resource}", to: "#{resource}#delete"
      end
    end
  end





  get '/auth/facebook/callback', :to => 'sessions#create'
  get '/auth/failure', :to => 'sessions#failure'
  get '/logout', :to => 'sessions#destroy'
end
