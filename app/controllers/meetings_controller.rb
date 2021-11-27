# frozen_string_literal: true

class MeetingsController < ApplicationController
  before_action :set_meeting, only: %i[show update destroy]
  def index
    meetings = params[:room_id] ? Meeting.where(room_id: params[:room_id]) : Meeting.all
    render json: meetings
  end

  def show
    render json: @meeting
  end

  def create
    @meeting = Meeting.new(meeting_params)
    @meeting.save!
    
    render json: @meeting, status: :created
  end

  def update
    @meeting.update!(meeting_params)
    render json: @meeting
  end

  def destroy
    @meeting.destroy!

    head :ok
  end

  private

  def set_meeting
    @meeting = Meeting.find(params[:id])
  end

  def meeting_params
    params.permit(:title, :starts_at, :ends_at, :room_id)
  end
end
