Rails.application.routes.draw do

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post '/authenticate', to: 'authentication#authenticate'

  # Users
  get '/users/', to: 'users/users#index'
  post '/users/', to: 'users/users#create'
  get '/users/:id', to: 'users/users#show'
  put '/users/:id', to: 'users/users#update'
  delete '/users/:id', to: 'users/users#destroy'

  # Rooms
  get '/rooms/', to: 'rooms/rooms#index'
  post '/rooms/', to: 'rooms/rooms#create'
  get '/rooms/:id', to: 'rooms/rooms#show'
  put '/rooms/:id', to: 'rooms/rooms#update'
  delete '/rooms/:id', to: 'rooms/rooms#destroy'

  # Schedule Room
  get '/schedule_room/', to: 'schedule_room/schedule_room#index'
  post '/schedule_room/', to: 'schedule_room/schedule_room#create'
  get '/schedule_room/:id', to: 'schedule_room/schedule_room#show'
  put '/schedule_room/:id', to: 'schedule_room/schedule_room#update'
  delete '/schedule_room/:id', to: 'schedule_room/schedule_room#destroy'
end
