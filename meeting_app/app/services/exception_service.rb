# frozen_string_literal: true

module ExceptionService
  class ScheduleAlreadyTakenException < RuntimeError; end

  class RoomNotFoundException < RuntimeError; end

  class ScheduleNotFoundException < RuntimeError; end

  class InvalidParamsException < RuntimeError

    attr_accessor :params

    def initialize(params_exception)
      super
      @params = params_exception
    end

  end

  class ModelErrorException < RuntimeError

    attr_accessor :errors

    def initialize(errors_exception)
      super
      raise ArgumentError unless errors_exception.is_a?(ActiveModel::Errors)

      @errors = errors_exception
    end

  end
end
