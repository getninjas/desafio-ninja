class Scheduling
  include Mongoid::Document
  include Mongoid::Timestamps

  field :date,                          type: Date
  field :time,                          type: Time
  field :duration,                      type: Integer

  belongs_to :room,                     class_name: 'Room'

  validates :date, presence: true
  validates :time, presence: true
  validates :duration, presence: true
  validate :check_business_day, :check_availability

  def check_business_day
    if [5, 6].include? date.wday
      errors.add(:availability, 'Non-working day')
      false
    else
      true
    end
  end

  def check_availability
    return unless (check_business_day)

    day = room.days.find_by(week_day: date.wday).set_date(time)
    if (((time + duration.minutes) <= day.time_to) && (time >= day.time_from))
      room.schedulings.where(date: date).asc(:time).each do |scheduling|
        next unless time >= scheduling.time &&
                    time <= scheduling.time + scheduling.duration.minutes

        errors.add(:availability, 'Time coincides with another appointment')
        break
      end
    else
      errors.add(:availability, 'Out of business hours')
    end
  end
end
