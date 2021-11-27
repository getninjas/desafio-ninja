Rails.application.routes.draw do
  resources :rooms, only: [:index]
end
