Rails.application.routes.draw do

  #Instagator/DinnerPoll routes

  root to: 'pages#home'

  get '/instagator', to: 'pages#dinner_poll', as: 'dinner_poll'

  get '/dashboard', to: 'users#dashboard', as: 'dashboard'
  post '/activate', to: 'users#activate', as: 'activation'

  resources :events, only: [:create, :show] do
    get '/polls/find_or_create', to: 'polls#find_or_create', as: 'find_or_create_poll'
  end
  get '/events/:id/take', to: 'events#route', as: 'route_event'
  get '/events/:id/generate_poll', to: 'events#generate_poll', as: 'generate_poll'

  resources :polls, only: [:show] do
    resources :choices, only: [:index]
  end

  get '/polls/:id/rsvp', to: 'polls#rsvp', as: 'rsvp'

  resources :choices, only: [:create]
  get '/choices/:id/vote', to: 'choices#vote', as: 'vote'
  get '/polls/:id/decide_vote', to:'choices#decide_vote', as: 'decide_vote'

  resources :services, only: [:index]
  get '/opentable', to: 'services#opentable', as: 'opentable'
  post '/opentable/search', to: 'services#opentable_search', as: 'opentable_search'


  # Optionize Routes

  namespace :simple do 
    resources :events
  end


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
