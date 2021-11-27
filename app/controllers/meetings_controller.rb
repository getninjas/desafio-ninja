class MeetingsController < ApplicationController
  before_action :set_meeting, only: [:show, :update, :destroy]
  def index
    meetings = params[:room_id] ? Meeting.where(room_id: params[:room_id]) : Meeting.all
    render json: meetings
  end

  def show
    render json: @meeting
  end

  def create
    @meeting = Meeting.new(meeting_params)

    if @meeting.save
      render json: @meeting, status: :created
    else
      render json: @meeting.errors, status: :unprocessable_entity
    end
  end

  private 
  
  def set_meeting
    @meeting = Meeting.find(params[:id])
  end

  def meeting_params
    params.permit(:title, :starts_at, :ends_at, :room_id)
  end
end
