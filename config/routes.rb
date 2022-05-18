Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  namespace :api, defaults: { format: :json } do
    scope module: :v1 do
      mount_devise_token_auth_for 'User', at: 'auth'
      resources :meeting, only: %i[show create update destroy]
      get '/my_created_meetings', to: 'meeting#my_created_meetings'
      get '/my_meetings_invitations', to: 'meeting#my_meetings_invitations'
    end
  end
end
