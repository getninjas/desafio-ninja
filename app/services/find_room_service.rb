# frozen_string_literal: true

class FindRoomService
  def initialize(start_time_candidate, end_time_candidate)
    @start_time_candidate = start_time_candidate
    @end_time_candidate = end_time_candidate
  end

  def find
    Room.all.each do |room|
      return room.id if room.meetings.blank?

      meeting_conflict = room.meetings.select do |meeting|
        (start_time_candidate..end_time_candidate).overlaps?(meeting.start_time, meeting.end_time)
      end

      return room.id if meeting_conflict.blank?
    end
    nil
  end
end
