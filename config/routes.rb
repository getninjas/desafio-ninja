Rails.application.routes.draw do
  resources :schedules, only: %i(index)
end
