Rails.application.routes.draw do
  resources :rooms, only: [:index]
  resources :meetings, only: [:index, :show, :create, :update, :destroy]
end
