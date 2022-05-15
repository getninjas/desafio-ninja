Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'

  resources :meeting, only: %i[show create update destroy]
  get '/my_created_meetings', to: 'meeting#my_created_meetings'
  get '/my_meetings_invitations', to: 'meeting#my_meetings_invitations'
end
