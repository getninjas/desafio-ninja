class TimeArray
  class << self
    def get_times_by_hour(start_time, end_time)
      times = []
      (start_time.to_datetime.to_i .. end_time.to_datetime.to_i).step(1.hour) do |time|
        times.push(Time.at(time).utc.strftime("%H:%M"))
      end
      times
    end
  end
end