class MeetingController < ApplicationController
  before_action :authenticate_user!
  before_action :find_meeting, only: %i[show update destroy]
  before_action :check_my_meetings, only: %i[show]
  before_action :check_my_created_meetings, only: %i[update destroy]

  def my_created_meetings
    @my_created_meetings = current_user.created_meetings
    render :my_created_meetings, status: :ok if @my_created_meetings.present?
  end

  def create
  end

  def update
  end

  def show; end

  private

  def permitted_params
    params.require(:meeting).permit(
      :start_time,
      :end_time,
      :room_id,
      :subject
    )
  end

  def formatted_params
    permitted_params.merge!(users_emails: params[:users_emails])
  end

  def find_meeting
    @meeting = Meeting.find(params[:id])
  end

  def check_my_meetings
    unless current_user.meetings.include?(@meeting) ||
      current_user.created_meetings.include?(@meeting)
      render json: { message: "You have to belong this meeting to do this action." },
             status: :forbidden
      return
    end
  end

  def check_my_created_meetings
    unless current_user.created_meetings.include?(@meeting)
      render json: { message: "You have to own this meeting to do this action." },
             status: :forbidden
      return
    end
  end

  end
end
