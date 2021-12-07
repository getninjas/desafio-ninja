class Api::V1::MeetingsController < Api::V1::ApiController

  before_action :set_meeting, only: [:show, :update, :destroy]

  # GET /api/v1/organizations/{:org_id}/rooms/{:room_id}/meetings
  def index
    @meetings = Meeting.where(room_id: params[:room_id])

    render json: @meetings
  end

  # GET /api/v1/organizations/{:org_id}/rooms/{:room_id}/meetings/{:meeting_id}
  def show
    render json: @meeting
  end

  # POST /api/v1/organizations/{:org_id}/rooms/{:room_id}/meetings
  def create
    @meeting = Meeting.new(meeting_params)

    if @meeting.save
      render json: @meeting, status: :created
    else
      render json: @meeting.errors, status: :unprocessable_entity
    end

  end

  # PUT /api/v1/organizations/{:org_id}/rooms/{:room_id}/meetings/{:meeting_id}
  def update
    if @meeting.update(meeting_params)
      render json: @meeting
    else
      render json: @meeting.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/organizations/{:org_id}/rooms/{:room_id}/meetings/{:meeting_id}
  def destroy
    @meeting.destroy
    render json: "Reunião excluida com sucesso", status: :ok
  end

  private
    def set_meeting
      @meeting = Meeting.find(params[:id])
    end

    def meeting_params
      params.permit(:starts_at, :end_at, :room_id)
    end

end
