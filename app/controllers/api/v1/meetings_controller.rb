class Api::V1::MeetingsController < Api::V1::ApiController

  before_action :set_meeting, only: [:show, :update, :destroy]

  # GET /api/v1/rooms
  def index
    @meetings = Meeting.all

    render json: @meetings
  end

  # GET /api/v1/rooms/{id}
  def show
    render json: @meeting
  end

  # POST /api/v1/rooms
  def create
    @meeting = Meeting.new(meeting_params)

    if @meeting.save
      render json: @meeting, status: :created
    else
      render json: @meeting.errors, status: :unprocessable_entity
    end

  end

  # PUT /api/v1/rooms/{id}
  def update
    if @meeting.update(meeting_params)
      render json: @meeting
    else
      render json: @meeting.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/rooms/{id}
  def destroy
    @meeting.destroy
  end

  private
    def set_meeting
      @meeting = Meeting.find(params[:id])
    end

    def meeting_params
      params.permit(:starts_at, :end_at, :room_id)
    end

end
