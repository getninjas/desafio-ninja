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
    if [5, 6].include? self.date.wday
      errors.add(:availability, 'Dia não útil')
    end
  end

  def check_availability
    day = self.room.days.find_by(week_day: self.date.wday)
    if (((self.time + self.duration.minutes) <= day.time_to) &&
      (self.time >= day.time_from))
      room.schedulings.where(date: self.date).asc(:time).each do |scheduling|
        if self.time >= scheduling.time &&
          self.time <= scheduling.time + scheduling.duration.minutes
          errors.add(:availability, 'Horário coincide com outro agendamento')
        end
      end
    else
      errors.add(:availability, 'Fora de horário comercial')
    end
  end
end
