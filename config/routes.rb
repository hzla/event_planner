Rails.application.routes.draw do
  
  root to: 'pages#home'
 
  get '/dashboard', to: 'users#dashboard', as: 'dashboard'
  
  resources :events
  get '/events/:id/activate', to: 'events#activate', as: 'activate'
  get '/events/:id/take', to: 'events#route', as: 'route_event'
  get '/events/:id/generate_poll', to: 'events#generate_poll', as: 'generate_poll'
  get '/invite_friends', to: 'events#invite_friends', as: 'invite_friends'
  get '/booking_info', to: 'events#booking_info', as: 'booking_info'

  resources :polls 
  get '/polls/:id/delete', to: 'polls#delete', as: 'delete_poll'
  get '/polls/:id/take', to: 'polls#take', as: 'take'

  resources :choices
  get '/choices/:id/vote', to: 'choices#vote', as: 'vote'
  get '/polls/:id/decide_vote', to:'choices#decide_vote', as: 'decide_vote'


  resources :services, only: [:index, :show]
  get '/opentable', to: 'services#opentable', as: 'opentable'
  post '/opentable/search', to: 'services#opentable_search', as: 'opentable_search'
  
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

      ["users", "events", "polls", "choices"].each do |resource|
        delete "/#{resource}", to: "#{resource}#delete"
      end
    end
  end

  get '/auth/facebook/callback', :to => 'sessions#create'
  get '/logout', :to => 'sessions#destroy'
end
