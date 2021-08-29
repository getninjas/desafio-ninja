class Room < ApplicationRecord

  has_many :schedule_rooms, dependent: :destroy

  def as_json(options={})
      h = super(options)
      h[:start_time] = self.start_time.strftime("%H:%M")
      h[:end_time] = self.end_time.strftime("%H:%M")
      h
  end

  def get_schedule_by_date(date)
     array = {date: date, times: []}
     TimeArray.get_times_by_hour(self.start_time, self.end_time).each do |hour|
       scheduled = schedule_rooms.find_by(scheduled_date: date, scheduled_time: hour)
       array[:times] << {time: hour, available: scheduled.nil?, by: scheduled&.user&.name}
     end
     array
   end
end
