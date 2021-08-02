Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :rooms do
        resources :schedules, defaults: { format: :json }
      end
    end
  end
end
