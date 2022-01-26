module Api
  module V1
    class SalaSerializer < ActiveModel::Serializer
      attributes :id, :nome
      has_one :agenda
    end
  end
end
