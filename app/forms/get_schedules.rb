class GetSchedules
  def self.perform
    rooms = Room.all.joins(:schedules)
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
