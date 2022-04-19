# frozen_string_literal: true

module CRUDManagement
  class Show
    include ActiveModel::Model
    attr_reader :callbacks, :instance, :params, :klass

    validates :instance, presence: {message: :not_found}

    def self.perform(params, callbacks, klass)
      new(params, callbacks, klass).show
    end

    def initialize(params, callbacks, klass)
      @params = params
      @callbacks = callbacks
      @klass = klass
    end

    def show
      @instance = load_object
      if valid?
        callbacks[:success]&.call(instance)
      else
        callbacks[:error]&.call(self)
      end
    end

    private

    def load_object
      klass.find_by(params)
    end
  end
end
