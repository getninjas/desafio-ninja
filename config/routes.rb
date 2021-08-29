Rails.application.routes.draw do
  resources :rooms
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post '/authenticate', to: 'authentication#authenticate'

  # Users
  post '/users/', to: 'users/users#create'
  get '/users/:id', to: 'users/users#show'
  put '/users/:id', to: 'users/users#update'
  delete '/users/:id', to: 'users/users#destroy'

  # Rooms
  post '/rooms/', to: 'rooms/rooms#create'
  get '/rooms/:id', to: 'rooms/rooms#show'
  put '/rooms/:id', to: 'rooms/rooms#update'
  delete '/rooms/:id', to: 'rooms/rooms#destroy'
end
