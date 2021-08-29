class ScheduleRoom < ApplicationRecord
  belongs_to :user
  belongs_to :room

  before_create :validate_schedule_room
  before_update :validate_schedule_room

  validates :scheduled_date, presence: true
  validates :time, presence: true

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
    raise 'time is invalid!' if self.time < room.start_time || self.time > room.end_time
  end

  def check_if_room_is_available
    scheduled_rooms = ScheduleRoom.where(room_id: self.room_id, scheduled_date: self.scheduled_date)
    room_unavailable = false

    scheduled_rooms.each do |scheduled_room|
      room_unavailable = true if self.time == scheduled_room.time
    end
    raise 'This room is unavailable to this time!' if room_unavailable
  end
end
