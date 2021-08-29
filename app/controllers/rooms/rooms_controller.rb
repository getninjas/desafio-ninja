class RoomsController < ApplicationController
  before_action :set_room, only: [:show, :update, :destroy]
  skip_before_action :authenticate_request, only: %i[create]

  def show
    if @room
      render json: { room: @room}, status: :ok
    else
      render status: :not_found
    end
  end

  def create
    room = Room.new(room_params)
    if room.save
      render json: { room: room}, status: :created
    else
      render json: { errors: room.errors}, status: :unprocessable_entity
    end
  end

  def update
    if @room
      @room.update!(room_params)
      if @room.save
        render json: { room: @room}, status: :ok
      else
        render json: { errors: @room.errors}, status: :unprocessable_entity
      end
    else
      render status: :not_found
    end
  end

  def destroy
    if @room
      @room.destroy!
      render status: :ok
    else
      render status: :not_found
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_room
    @room = Room.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def room_params
    params.require(:room).permit(:name, :start_time, :end_time)
  end
end
