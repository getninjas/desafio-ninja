Rails.application.routes.draw do
  namespace :api do
    resources :schedules
  end
end
