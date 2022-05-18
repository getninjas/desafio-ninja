class Api::V1::MeetingRoomsController < Api::ApiController
  def index
    render json: MeetingRoom.all, status: :ok
  end

end
