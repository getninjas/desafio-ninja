module SchedulingTimeRules
  extend ActiveSupport::Concern

  private

  def valid_time_range
    return if time.on_weekday? && time.hour.between?(9, 18) && time > DateTime.current

    errors.add(:time, :out_of_time)
  end

  def valid_time_unique
    return if meeting_room.schedulings.find_by(time: time).nil?

    errors.add(:time, :taken)
  end

  def format_hour
    return errors.add(:time, :invalid) unless time.present?

    self.time = time.beginning_of_hour
  end

end
