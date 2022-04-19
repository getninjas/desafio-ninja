class Schedule < ApplicationRecord
  belongs_to :room
  belongs_to :user

  validates :start_time, :end_time, presence: true
  validate :validate_start_end_time, :validate_day, :validate_date, :validate_equal_hour, :validate_hour,
           :validate_start_and_end_range, :validate_schedule, if: -> { start_time.present? && end_time.present? }

  private

  def validate_start_end_time
    return if end_time > start_time

    errors.add(:base, I18n.t('api.errors.start_end_time_invalid'))
  end

  def validate_day
    return unless start_time.sunday? || start_time.saturday? || end_time.sunday? || end_time.saturday?

    errors.add(:base, I18n.t('api.errors.date_invalid'))
  end

  def validate_date
    return if start_time > DateTime.current && end_time > DateTime.current

    errors.add(:base, I18n.t('api.errors.date_hour_invalid'))
  end

  def validate_equal_hour
    return if (end_time - start_time).to_f > 0

    errors.add(:base, I18n.t('api.errors.duration_invalid'))
  end

  def validate_hour
    return if start_time.hour >= 9 && start_time.hour <= 18 && end_time.hour >= 9 && end_time.hour <= 18

    errors.add(:base, I18n.t('api.errors.time_invalid'))
  end

  def validate_start_and_end_range
    return if start_time.to_date == end_time.to_date

    errors.add(:base, I18n.t('api.errors.invalid_start_and_end_range'))
  end

  def validate_schedule
    schedules = Schedule.where("start_time::date = '#{start_time.to_date}' and room_id = '#{room_id}'")
    schedules.each do |schedule|
      unless schedule.id == id
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
end
