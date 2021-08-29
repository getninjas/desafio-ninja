class ScheduleRoom::ScheduleRoomController < ApplicationController
  before_action :set_schedule_room, only: [:show, :update, :destroy]

  def index
    render json: { schedule_rooms: ScheduleRoom.all }, status: :ok
  end

  def show
    if @schedule_room
      render json: { schedule_room: @schedule_room }, status: :ok
    else
      render status: :not_found
    end
  end

  def create
      unless schedule_room_params[:start_time].nil? && schedule_room_params[:end_time].nil?
        created_objects = []
        ScheduleRoom.transaction do
          MyLibTime.get_times_by_hour(schedule_room_params[:start_time], schedule_room_params[:end_time]).each do |hour|
            @schedule_room = ScheduleRoom.create( user_id: current_user.id,
                                                  room_id: schedule_room_params[:room_id],
                                                  scheduled_date: schedule_room_params[:scheduled_date],
                                                  scheduled_time: hour )
            created_objects.push(@schedule_room)
            @schedule_room.save!
          end
        end

        if @schedule_room.save
          render json: { schedule_room: created_objects }, status: :created
        else
          render json: { errors: @schedule_room.errors}, status: :unprocessable_entity
        end
      end
  rescue StandardError => e
    render json: { errors: e.message }, status: :unprocessable_entity
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
      params.permit(:room_id, :scheduled_date, :start_time, :end_time)
    end
end
