class MeetingController < ApplicationController
  before_action :find_meeting, only: %i[show update destroy]
  def my_created_meetings
    @my_created_meetings = current_user.created_meetings
    render :my_created_meetings, status: :ok if @my_created_meetings.present?
  end

  def create
  end

  def update
  end

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

  end

  def delete
  end
end
