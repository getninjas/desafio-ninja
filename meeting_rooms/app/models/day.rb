class Day
  include Mongoid::Document
  include Mongoid::Timestamps

  field :week_day,                       type: Integer
  field :time_from,                      type: Time
  field :time_to,                        type: Time

  embedded_in :room,                    class_name: 'Room'

  def set_date date_time
    self.time_from = self.time_from.change({day: date_time.day, month: date_time.month, year: date_time.year})
    self.time_to = self.time_to.change({day: date_time.day, month: date_time.month, year: date_time.year})
    self
  end
end
