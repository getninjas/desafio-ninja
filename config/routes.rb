Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :schedulings, only: [:index, :create, :update, :show, :destroy]
      resources :meeting_rooms, only: [:index]
    end
  end
end
