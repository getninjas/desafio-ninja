class SchedulesController < ApplicationController
  def index
    render json: { data: GetSchedules.perform }, status: 200
  end

  def create
    create_schedule = CreateSchedule.new(create_params)
    if create_schedule.perform
      render json: {
        data: {
          message: :success
        }
      }, status: 201
    else
      render json: { error: { message: create_schedule.errors.first.full_message } }, status: 422
    end

  rescue ActionController::ParameterMissing => e
    render json: { error: { message: "#{e.param} must not be empty" } }, status: 400
  end

  private

  def create_params
    params.require([:user_email, :room, :schedule]).last.require([:start_time, :end_time])
    params.permit(:user_email, :room, schedule: [:start_time, :end_time])
  end
end
