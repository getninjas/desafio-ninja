class ScheduleRoom < ApplicationRecord
  belongs_to :user
  belongs_to :room

  before_save :validate_schedule_room

  validates :scheduled_date, presence: true
  validates :scheduled_time, presence: true

  def as_json(options={})
    h = super(options)
    h[:scheduled_date] = MyLibTime.to_hours(self.scheduled_date)
    h[:scheduled_time] = MyLibTime.to_hours(self.scheduled_date)
    h
  end

  private

  def validate_schedule_room
    check_if_date_is_weekend
    check_if_scheduled_time_is_valid
    check_if_room_is_available
  end

  def check_if_date_is_weekend
    raise 'The meeting room is closed in weekend!' if self.scheduled_date.saturday? || self.scheduled_date.sunday?
  end

  def check_if_scheduled_time_is_valid
    raise "Ops! This meeting room is open in #{MyLibTime.to_hours(room.start_time)}." if self.scheduled_time < room.start_time
    end_time_available = MyLibTime.to_hours(room.end_time - 1.hour)
    raise "Ops! This meeting room is closed in #{MyLibTime.to_hours(room.end_time)}. Set end_time to #{end_time_available}" if self.scheduled_time >= room.end_time
  end

  def check_if_room_is_available
    scheduled_rooms = ScheduleRoom.where(room_id: self.room_id, scheduled_date: self.scheduled_date).where.not(id: self.id)
    room_unavailable = false

    scheduled_rooms.each do |scheduled_room|
      room_unavailable = true if self.scheduled_time == scheduled_room.scheduled_time
    end
    raise "This room is unavailable to this time (#{MyLibTime.to_hours(self.scheduled_time)})!" if room_unavailable
  end
end
