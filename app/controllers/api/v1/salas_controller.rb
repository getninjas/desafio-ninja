module Api
  module V1
    class SalasController < ApplicationController
      def index
        collection = Sala.order(:nome)
        render json: collection
      end

      def show
        render json: Sala.find(params[:id])
      end

      def agendas
        render json: Sala.find(params[:id]).agenda
      end

      def todos_agendamentos
        render json: Sala.find(params[:id]).agenda.agendamentos
      end

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
