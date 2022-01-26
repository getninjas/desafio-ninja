
module Api
  module V1
    class AgendamentoSerializer < ActiveModel::Serializer
      attributes :id, :data, :horario_inicio, :horario_final

      def horario_inicio
        object.horario_inicio.strftime('%H:%M')
      end

      def horario_final
        object.horario_final.strftime('%H:%M')
      end

      def data
        object.data.strftime('%d/%m/%Y')
      end
    end
  end
end
