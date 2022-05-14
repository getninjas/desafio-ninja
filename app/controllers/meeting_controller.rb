class MeetingController < ApplicationController
  def my_created_meetings
    @my_created_meetings = current_user.created_meetings
    render :my_created_meetings, status: :ok if @my_created_meetings.present?
  end

  def create
  end

  def update
  end

  def show
  end

  def delete
  end
end
