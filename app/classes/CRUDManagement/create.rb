# frozen_string_literal: true

module CRUDManagement
  class Create
    include ActiveModel::Model
    validate :instance_validations
    attr_reader :callbacks, :params, :instance, :klass

    def self.perform(params, callbacks, klass)
      new(params, callbacks, klass).create
    end

    def initialize(params, callbacks, klass)
      @params = params
      @callbacks = callbacks
      @klass = klass
    end

    def create
      @instance = load_object
      if valid?
        instance.save
        callbacks[:success]&.call(instance)
      else
        callbacks[:error]&.call(instance)
      end
    end

    private

    def load_object
      klass.new(params)
    end

    def instance_validations
      errors.merge!(@instance.errors) if instance.invalid?
    end
  end
end
