module Api
  module V1
    class AgendamentosController < ApplicationController
      api :GET, '/api/v1/agendamentos', 'Lista as todos agendamentos'
      def index
        collection = Agendamento.order(:horario_inicio)
        render json: collection
      end

      api :GET, '/api/v1/agendamentos/:id', 'Lista as informaçoes do agendamento'
      def show
        render json: Agendamento.find(params[:id])
      end

      api :delete, '/api/v1/agendamentos/:id', 'Apaga o agendamento'
      def destroy
        Agendamento.destroy(params[:id])
      end

      api :put, '/api/v1/agendamentos/:id', 'Edita o agendamento'
      def update
        agendamento = Agendamento.find(params[:id])
        render json: agendamento.update!(collection)
      end

      api :post, '/api/v1/agendamentos', 'Cria um agendamento params: :data, :horario_inicio, :horario_final'
      def create
        agendamento = Agendamento.new(collection)

        if agendamento.save
          render json: agendamento, status: :created
        else
          render json: { errors: agendamento.errors }, status: :unprocessable_entity
        end
      end

      private

      def collection
        params.permit(:horario_inicio, :horario_final, :data, :agenda_id)
      end
    end
  end
end
