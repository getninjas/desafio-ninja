class ScheduleRoom < ApplicationRecord
  belongs_to :user
  belongs_to :room

  before_create :validate_schedule_room
  before_update :validate_schedule_room

  validates :scheduled_date, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true

  private

  def validate_schedule_room
    check_if_date_is_weekend
    check_if_time_is_valid
    check_if_room_is_available
  end

  def check_if_date_is_weekend
    date = Date.parse(self.scheduled_date)
    raise 'The meeting room is closed in weekend!' if date.saturday? || date.sunday?
  end

  def check_if_time_is_valid
    raise 'start_time is invalid!' if self.start_time < room.start_time
    raise 'end_time is invalid!' if self.end_time < room.end_time
  end

  def check_if_room_is_available
    scheduled_rooms = ScheduleRoom.where(room_id: self.room_id, scheduled_date: self.scheduled_date)
    room_unavailable = false
    scheduled_rooms.each do |scheduled_room|
      unless (self.start_time < scheduled_room.start_time && self.end_time < scheduled_room.end_time) ||
        (self.start_time > scheduled_room.start_time && self.end_time > scheduled_room.end_time)
        room_unavailable = true
      end
    end
    raise 'This room is unavailable to this start_time and end_time!' if room_unavailable
  end
end
