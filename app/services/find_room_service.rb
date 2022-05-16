# frozen_string_literal: true

class FindRoomService
  def initialize(start_time_candidate, end_time_candidate)
    @start_time_candidate = start_time_candidate
    @end_time_candidate = end_time_candidate
    @rooms_ids = []
  end

  def find
    Room.all.each do |room|
      meeting_conflict = room.meetings.select do |meeting|
        (@start_time_candidate..@end_time_candidate).overlaps?(meeting.start_time..meeting.end_time)
      end

      (@rooms_ids << room.id; break) if meeting_conflict.blank?
    end

    @rooms_ids.uniq.first
  end
end
