Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :schedulings, only: [:index, :create, :update, :show, :destroy]
  resources :meeting_rooms, only: [:index]
end
