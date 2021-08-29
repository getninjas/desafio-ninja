Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  post '/authenticate', to: 'authentication#authenticate'

  # Users
  post '/users/', to: 'users/users#create'
  get '/users/:id', to: 'users/users#show'
  put '/users/:id', to: 'users/users#update'
  delete '/users/:id', to: 'users/users#destroy'
end
