module Api
  module V1
    class AgendamentosController < ApplicationController
      def index
        collection = Agendamento.order(:horario_inicio)
        render json: collection
      end

      def show
        render json: Agendamento.find(params[:id])
      end

      def destroy
        Agendamento.destroy(params[:id])
      end

      def update
        agendamento = Agendamento.find(params[:id])
        render json: agendamento.update!(collection)
      end

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
        params.require(:agendamento).permit(:horario_inicio, :horario_final, :data, :agenda_id)
      end
    end
  end
end
