class MyLibTime
  class << self
    def get_times_by_hour(start_time, end_time)
      times = []
      (start_time.to_datetime.to_i .. end_time.to_datetime.to_i).step(1.hour) do |time|
        times.push(Time.at(time).utc.strftime("%H:%M"))
      end
      times
    end

    def to_hours(time)
      time.strftime("%H:%M")
      end

    def to_date(date)
      date.strftime("%d/%m/%Y")
    end
  end
end