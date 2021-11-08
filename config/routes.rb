Rails.application.routes.draw do
  resources :schedules, only: %i(index create update)
end
