class ScheduleAvailabilityValidator
  def initialize(schedule)
    @schedule = schedule
  end

  def is_there_schedule_conflict_with?(record)
    is_start_time_between_a_schedule?(record) ||
    is_end_time_between_a_schedule?(record) ||
    is_a_schedule_between_start_and_end_time?(record)
  end

  private

  def is_start_time_between_a_schedule?(record)
    start_time >= record.start_time && start_time < record.end_time
  end

  def is_end_time_between_a_schedule?(record)
    end_time > record.start_time && end_time <= record.end_time
  end

  def is_a_schedule_between_start_and_end_time?(record)
    start_time <= record.start_time && record.end_time <= end_time
  end

  def start_time
    @schedule[:start_time].to_datetime
  end

  def end_time
    @schedule[:end_time].to_datetime
  end
end
