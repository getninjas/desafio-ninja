class UpdateSchedule
  include ActiveModel::Model
  validates_with ScheduleValidator

  attr_accessor :schedule

  def perform(id)
    schedule_to_update = Schedule.find(id)

    return false unless valid?

    availability_validator = ScheduleAvailabilityValidator.new(schedule)
    Schedule.transaction do
      Schedule
        .where("room_id = ? and start_time > ? and end_time < ?", schedule_to_update.room_id, start_time.beginning_of_day, end_time.end_of_day)
        .order(start_time: :asc)
        .lock!
        .each do |persisted_schedule|
          if availability_validator.is_there_schedule_conflict_with?(persisted_schedule)
              errors.add(:schedule, :invalid, message: 'not available')
              raise ActiveRecord::Rollback
          end
        end

      schedule_to_update.update!(
        start_time: start_time,
        end_time: end_time
      )
    end
  end

  def start_time
    schedule[:start_time].to_datetime
  end

  def end_time
    schedule[:end_time].to_datetime
  end
end
