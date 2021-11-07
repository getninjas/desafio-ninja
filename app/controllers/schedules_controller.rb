class SchedulesController < ApplicationController
  def index
    render json: { data: GetSchedules.perform }, status: 200
  end
end
