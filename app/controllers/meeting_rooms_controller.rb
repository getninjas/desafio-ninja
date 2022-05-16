class MeetingRoomsController < ApiController
  def index
    render json: MeetingRoom.all, status: :ok
  end

end
