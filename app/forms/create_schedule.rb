class CreateSchedule
  include ActiveModel::Model
  validates_with ScheduleValidator

  attr_accessor :user_email, :room_name, :schedule, :guests

  def perform
    return false unless valid?
    availability_validator = ScheduleAvailabilityValidator.new(schedule)

    Schedule.transaction do
      room = Room.find_by(name: room_name)
      Schedule
        .where("room_id = ? and start_time > ? and end_time < ?", room.id, start_time.beginning_of_day, end_time.end_of_day)
        .order(start_time: :asc)
        .lock!
        .each do |schedule|
          if availability_validator.is_there_schedule_conflict_with?(schedule)
              errors.add(:schedule, :invalid, message: 'not available')
              raise ActiveRecord::Rollback
          end
        end

      schedule = Schedule.create!(
        room: room,
        user: User.find_by(email: user_email),
        start_time: start_time,
        end_time: end_time
      )


      if guests&.is_a? Array
        persisted_guests = guests.map do |guest|
          break unless guest.is_a?(Hash) && guest.dig(:email)
          Guest.find_or_create_by(email: guest[:email])
        end
      end

      if(persisted_guests&.size)
        schedule.guests << persisted_guests
        SendEmailToGuestsWorker.perform_async(schedule.id)
      end

      schedule
    end
  end

  private

  def start_time
    @start_time ||= schedule[:start_time].to_datetime
  end

  def end_time
    @end_time ||= schedule[:end_time].to_datetime
  end
end
