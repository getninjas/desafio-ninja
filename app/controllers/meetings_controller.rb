class MeetingsController < ApplicationController
  before_action :set_meeting, only: [:show, :update, :destroy]
  def index
    meetings = params[:room_id] ? Meeting.where(room_id: params[:room_id]) : Meeting.all
    render json: meetings
  end

  def show
    render json: @meeting
  end

  private 
  
  def set_meeting
    @meeting = Meeting.find(params[:id])
  end
end
