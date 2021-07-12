class Appointment < ActiveRecord::Base
  # Associations
  belongs_to :room

  # Validations
  validates :responsible_name, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :room, presence: true
  validate :time_window_disjunction
  validate :room_availability
  validate :time_interval

  def intersects_another_appointment?
    Appointment.where(room_id: room_id)
               .where.not(id: id)
               .where('start_time >= ? AND start_time <= ?', start_time, end_time)
               .or(
                   Appointment.where(room_id: room_id)
                              .where.not(id: id)
                              .where('start_time <= ? AND end_time >= ?', start_time, start_time)
                ).exists?
  end

  def respect_room_availability?
    return true if room.blank?

    return false if end_time - start_time >= 24.hours.to_i

    return false if room.availability_days.exclude?(start_time.wday)

    return false if start_time.seconds_since_midnight < Time.parse(room.availability_start_time).seconds_since_midnight

    return false if start_time.seconds_since_midnight > Time.parse(room.availability_end_time).seconds_since_midnight

    return false if end_time.seconds_since_midnight > Time.parse(room.availability_end_time).seconds_since_midnight

    true
  end

  private

  def time_window_disjunction
    return true unless self.intersects_another_appointment?

    errors.add(:base, 'cannot intersect another appointment')
    return false
  end

  def room_availability
    return true if self.respect_room_availability?

    errors.add(:base, 'must respect room availability')
    return false
  end

  def time_interval
    return true if self.start_time < self.end_time

    errors.add(:base, 'end_time must be greater than start_time')
    return false
  end
end