Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'

  resources :meetings, only: %i[show create update destroy]
  get '/my_meetings', to: 'meeting#my_meetings'
end
