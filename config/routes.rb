Rails.application.routes.draw do
  
  root to: 'pages#home'
 
  get '/dashboard', to: 'users#dashboard', as: 'dashboard'
  
  resources :events, only: [:create, :show] do 
    get '/polls/find_or_create', to: 'polls#find_or_create', as: 'find_or_create_poll'
  end
  get '/events/:id/take', to: 'events#route', as: 'route_event'
  get '/events/:id/generate_poll', to: 'events#generate_poll', as: 'generate_poll'

  resources :polls, only: [:show] do 
    resources :choices, only: [:index]
  end

  resources :choices, only: [:create]
  get '/choices/:id/vote', to: 'choices#vote', as: 'vote'
  get '/polls/:id/decide_vote', to:'choices#decide_vote', as: 'decide_vote'

  resources :services, only: [:index]
  get '/opentable', to: 'services#opentable', as: 'opentable'
  post '/opentable/search', to: 'services#opentable_search', as: 'opentable_search'
  



  # API ROUTES

  namespace :api, :defaults => {:format => :json} do
    namespace :v1 do
      resources :users
      post '/users/:id', to: 'users#update' 
     
      resources :events
      post '/events/:id', to: 'events#update'
      get '/events/search', to: 'events#search'
      get '/events/activate', to: 'events#activate'
      
      resources :polls 
      
      resources :choices
      post '/choices/vote', to: 'choices#vote'
      
      resources :services, only: [:index]
      
      resources :authorizations

      resources :restaurants, only: [:index]
      ["users", "events", "polls", "choices"].each do |resource|
        delete "/#{resource}", to: "#{resource}#delete"
      end
    end
  end

  get '/auth/facebook/callback', :to => 'sessions#create'
  get '/logout', :to => 'sessions#destroy'
end
