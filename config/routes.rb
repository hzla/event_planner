Rails.application.routes.draw do
  root to: 'pages#home'

  get '/s1', to: 'pages#screen_one'
  get '/s2', to: 'pages#screen_two'
end
