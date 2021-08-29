class Room < ApplicationRecord

  has_many :schedule_rooms, dependent: :destroy

  def as_json(options={})
      h = super(options)
      h[:start_time] = MyLibTime.to_hours(self.start_time)
      h[:end_time] = MyLibTime.to_hours(self.end_time)
      h
  end

  def get_schedule_by_date(date)
     array = {date: date, times: []}
     MyLibTime.get_times_by_hour(self.start_time, self.end_time).each do |hour|
       scheduled = schedule_rooms.find_by(scheduled_date: date, scheduled_time: hour)
       array[:times] << {time: hour, available: scheduled.nil?, by: scheduled&.user&.name}
     end
     array
   end
end
