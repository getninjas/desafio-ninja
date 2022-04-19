class Schedule < ApplicationRecord
  belongs_to :room
  belongs_to :user

  validates :start_time, :duration, :end_time, presence: true
  validate :validate_start_end_time, :validate_day, :validate_hour, :validate_schedule

  private

  def validate_start_end_time
    return if end_time > start_time

    errors.add(:base, I18n.t('api.errors.start_end_time_invalid'))
  end

  def validate_day
    return unless start_time.sunday? || start_time.saturday? || end_time.sunday? || end_time.saturday?

    errors.add(:base, I18n.t('api.errors.date_invalid'))
  end

  def validate_hour
    return if start_time.hour >= 9 && start_time <= 18 && end_time.hour >= 9 && end_time <= 18

    errors.add(:base, I18n.t('api.errors.time_invalid'))
  end

  def validate_schedule
    schedules = Schedule.where("start_time::date = '#{start_time.to_date}'")

    schedules.each do |schedule|
      if (schedule.start_time..schedule.end_time) === start_time
        errors.add(:base, I18n.t('api.errors.time_not_available'))
      else
        if (schedule.start_time..schedule.end_time) === end_time
          errors.add(:base, I18n.t('api.errors.time_not_available'))
        end
      end
    end
  end
end
