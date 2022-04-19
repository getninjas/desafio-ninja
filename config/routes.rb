Rails.application.routes.draw do
  namespace :api do
    devise_for :users,
               path: '',
               path_names: {
                 sign_in: 'login',
                 sign_out: 'logout'
               },
               controllers: {
                 sessions: 'api/sessions',
                 passwords: 'api/passwords'
               }, defaults: { format: :json }

    resources :users, only: [:index, :show, :update, :create]
    resources :rooms, only: [:index, :show]
  end
end
