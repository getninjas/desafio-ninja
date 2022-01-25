Rails.application.routes.draw do
  all_routes = %i[index new create edit update show destroy]

  namespace 'api' do
    namespace 'v1' do
      resources :salas, only: %i[index show] do
        member do
          get 'agendas'
          get 'todos_agendamentos'
          post 'buscar_agendamento'
        end
      end

      resources :agendamentos, only: all_routes
    end
  end
end
