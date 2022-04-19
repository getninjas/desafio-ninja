# frozen_string_literal: true

module Deserialization
  module HasMany
    def deserialize_nested(rel, key)
      rel_params = rel['data'].map do |e|
        e.select { |k, _| %i[id attributes action].include?(k.to_sym) }
      end

      rel_params.each do |obj|
        raise ArgumentError, I18n.t('api.errors.action_not_provided') unless obj.key?('action')
      end

      {"#{key}_attributes".to_sym => rel_params.map { |e| e.merge(e.delete('attributes') { {} }) }}
    end
  end
end
