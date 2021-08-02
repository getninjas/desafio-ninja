class Schedule < ApplicationRecord
  START_TIME = '09:00'
  END_TIME = '18:00'

  attr_reader :time_range

  belongs_to :room

  validates :scheduled_by, presence: true
  validates :start_at, presence: true
  validates :end_at, presence: true
  validate :is_time_range_valid

  private

  def is_time_range_valid
    if (self.start_at && self.end_at)
      errors.add(:start_at, :start_at_less_than_end_at) unless (self.start_at < self.end_at)
      errors.add(:time_range, :scheduled_time) if is_scheduled?
      errors.add(:time_range, :out_of_range) if !is_in_business_time?
    else
      return false
    end
  end

  def is_scheduled?
    time_range = self.start_at..self.end_at
    schedules = Schedule.arel_table

    query = schedules[:room_id].eq(self.room_id)
      .and(schedules[:id].not_eq(self.id))
      .and(
        schedules[:start_at].between(time_range)
        .or(schedules[:end_at].between(time_range))
      )

    !Schedule.where(query).empty?
  end

  def is_in_business_time?

    is_start_time_in_commercial_range? && is_end_time_in_commercial_range?
  end

  def is_start_time_in_commercial_range?
    self.start_at.on_weekday? && self.start_at.between?(START_TIME, END_TIME)
  end

  def is_end_time_in_commercial_range?
    self.end_at.on_weekday? && self.end_at.between?(START_TIME, END_TIME)
  end
end
