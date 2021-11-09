Rails.application.routes.draw do
  post 'auth/token'
  resources :schedules, only: %i(index create update destroy)
end
