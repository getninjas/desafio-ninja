module Api
  module V1
    class AgendaSerializer < ActiveModel::Serializer
      attributes :id, :agendamentos

      def agendamentos
        object.agendamentos.map do |agendamento|
          AgendamentoSerializer.new(agendamento)
        end
      end
    end
  end
end
