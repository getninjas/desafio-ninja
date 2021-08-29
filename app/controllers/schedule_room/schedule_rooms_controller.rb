class ScheduleRoomsController < ApplicationController
  before_action :set_schedule_room, only: [:show, :update, :destroy]
  skip_before_action :authenticate_request, only: %i[create]

  def show
    if @schedule_room
      render json: { schedule_room: @schedule_room}, status: :ok
    else
      render status: :not_found
    end
  end

  def create
    @schedule_room = ScheduleRoom.new(schedule_room_params)

    if @schedule_room.save
      render json: { schedule_room: @schedule_room}, status: :created
    else
      render json: { errors: @schedule_room.errors}, status: :unprocessable_entity
    end
  end

  def update
    if @schedule_room
      @schedule_room.update!(schedule_room_params)
      if @schedule_room.save
        render json: { schedule_room: @schedule_room}, status: :ok
      else
        render json: { errors: @schedule_room.errors}, status: :unprocessable_entity
      end
    else
      render status: :not_found
    end
  end

  def destroy
    if @schedule_room
      @schedule_room.destroy!
      render status: :ok
    else
      render status: :not_found
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_schedule_room
      @schedule_room = ScheduleRoom.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def schedule_room_params
      params.require(:schedule_room).permit(:user_id, :room_id, :scheduled_date, :start_time, :end_time)
    end
end
