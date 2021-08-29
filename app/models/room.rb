class Room < ApplicationRecord

  has_many :schedule_rooms

   def get_schedule_by_date(date)
     array = {date: date, times: []}
     get_times_by_hour.each do |hour|
       scheduled = schedule_rooms.find_by(scheduled_date: date, time: hour)
       array[:times] << {time: hour, available: scheduled.nil?, by: scheduled&.user&.name}
     end
     array
   end

  private

  def get_times_by_hour
    times = []
    (self.start_time.to_datetime.to_i .. self.end_time.to_datetime.to_i).step(1.hour) do |time|
      times.push(Time.at(time).utc.strftime("%H:%M"))
    end
    times
  end

end
