module Api
  module V1
    class SalasController < ApplicationController
      api :GET, '/api/v1/salas', 'Lista as todas salas e agendamentos'
      def index
        collection = Sala.order(:nome)
        render json: collection
      end

      api :GET, '/api/v1/salas/:id', 'Lista a informação da salas e agendamentos'
      def show
        render json: Sala.find(params[:id])
      end

      api :GET, '/api/v1/salas/:id/agendas', 'Lista a informação da agendas e agendamentos'
      def agendas
        render json: Sala.find(params[:id]).agenda
      end

      api :GET, '/api/v1/salas/:id/todos_agendamentos', 'Lista a informação dos agendamentos'
      def todos_agendamentos
        render json: Sala.find(params[:id]).agenda.agendamentos
      end

      api :POST, '/api/v1/salas/:id/buscar_agendamento', 'Busca a informação dos agendamentos Atravéz de um ou mais parâmetros sendo eles: :data, :horario_inicio, :horario_final '
      def buscar_agendamento
        render json: Sala.find(params[:id]).agenda.agendamentos.where(agendamento_collection)
      end

      private

      def agendamento_collection
        params.permit(:data, :horario_inicio, :horario_final)
      end
    end
  end
end
