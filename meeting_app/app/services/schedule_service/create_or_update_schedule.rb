# frozen_string_literal: true

module ScheduleService
  class CreateOrUpdateSchedule < ApplicationService

    include ::ValidateParamsHelper

    attr_reader :title, :date, :start_hour, :end_hour, :room, :schedule

    def initialize(params = {}, room, schedule)
      @id         = params[:id]
      @title      = params[:title]
      @date       = params[:date]
      @start_hour = params[:start_hour]
      @end_hour   = params[:end_hour]
      @schedule   = schedule
      @room       = room
    end

    def before
      @schedule ? validate_params(attributes_update) : validate_params(attributes)
    end

    def after; end

    def call
      already_scheduled?
      register
    end

    private

    def already_scheduled?
      return unless @start_hour

      Schedule.where(date: @date, room_id: @room.id).map do |meeting|
        if (meeting.start_hour..meeting.end_hour).to_a.flatten.include? @start_hour
          raise ExceptionService::ScheduleAlreadyTakenException
        end
      end
    end

    def attributes
      {
        title: @title,
        date: @date,
        start_hour: @start_hour,
        end_hour: @end_hour,
        room_id: @room.id
      }
    end

    def attributes_update
      {
        title: @title || @schedule.title,
        date: @date || @schedule.date,
        start_hour: @start_hour || @schedule.start_hour,
        end_hour: @end_hour || @schedule.end_hour,
        room_id: @room.id
      }
    end

    # ExceptionService::ModelErrorException
    def register
      form = Form::ScheduleForm.new(attributes_update.merge({ id: @id }))
      return if form.register

      raise ExceptionService::ModelErrorException.new(form.errors)
    end

  end
end
