class Day
  include Mongoid::Document
  include Mongoid::Timestamps

  field :week_day,                       type: Integer
  field :time_from,                      type: Time
  field :time_to,                        type: Time

  embedded_in :room,                    class_name: 'Room'

  def set_date(date_time)
    time_from = time_from.change({ day: date_time.day, month: date_time.month, year: date_time.year })
    time_to = time_to.change({ day: date_time.day, month: date_time.month, year: date_time.year })
    self
  end
end
