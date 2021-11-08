class ScheduleValidator < ActiveModel::Validator
  def validate(record)
    @record = record

    if start_time > end_time
      record.errors.add(:schedule, :invalid, message: 'start_time must not be greater than end_time')
    end

    # TODO: Handle timezone
    if start_time.hour < 9 || start_time.hour > 18 || end_time.hour < 9 || end_time.hour > 18
      record.errors.add(:schedule, :invalid, message: 'must be within work hours')
    end

    if start_time.day != end_time.day
      record.errors.add(:schedule, :invalid, message: 'must be in the same day')
    end
  end

  private

  def start_time
    @record.schedule[:start_time].to_datetime
  end

  def end_time
    @record.schedule[:end_time].to_datetime
  end
end
