# frozen_string_literal: true

module Api
  class SchedulesController < ::ApplicationController

    before_action :find_schedule, only: %i[show destroy update]

    rescue_from ActiveRecord::RecordNotFound, with: :error_not_found
    rescue_from ExceptionService::RoomNotFoundException, with: :room_not_found
    rescue_from ExceptionService::ScheduleAlreadyTakenException, with: :already_scheduled
    rescue_from ExceptionService::InvalidParamsException, with: :error_bad_request

    def index
      @schedules = Schedule.all
      render json: @schedules
    end

    def show
      render json: @schedule, status: :ok
    end

    def create
      ScheduleService::CreateOrUpdateSchedule.call(params, room, nil)
      render json: { message: 'Reunião Criada', data: Schedule.last }, status: :ok
    rescue ExceptionService::ModelErrorException => e
      render json: { error: e.errors }, status: :bad_request
    end

    def update
      ScheduleService::CreateOrUpdateSchedule.call(params, room, @schedule)
      render json: { message: 'Reunião Editada', data: @schedule }, status: :ok
    rescue ExceptionService::ModelErrorException => e
      render json: { error: e.errors }, status: :bad_request
    end

    def destroy
      render json: { message: 'Reunião Excluída' }, status: :no_content if @schedule.destroy
    end

    private

    def already_scheduled
      render json: { error: I18n.t('services.errors.schedule_already_taken') }, status: :unprocessable_entity
    end

    def error_not_found
      msg = I18n.t('services.errors.model_not_found_female', model: Schedule.model_name.human)
      render json: { error: msg }, status: :not_found
    end

    def room_not_found
      msg = I18n.t('services.errors.model_not_found_female', model: Room.model_name.human)
      render json: { error: msg }, status: :not_found
    end

    def error_bad_request(errors)
      render json: errors.params, status: :bad_request
    end

    def find_schedule
      @schedule = Schedule.find(params[:id])
    end

    def room
      obj = Room.find_by_id(params[:room_id] || Schedule.find(params[:id]).room_id)
      raise ExceptionService::RoomNotFoundException unless obj

      obj
    end

  end
end
