class GetSchedules
  include ActiveModel::Model

  def perform
    rooms = Room.includes(:schedules).joins(:schedules)
    {
      rooms: rooms.map do |room|
        {
          room.name => room.schedules.map do |schedule|
            {
              start_time: schedule.start_time.strftime('%Y-%m-%d %H:%M:%S'),
              end_time: schedule.end_time.strftime('%Y-%m-%d %H:%M:%S'),
            }
          end
        }
      end
    }
  end
end
