class Day
  include Mongoid::Document
  include Mongoid::Timestamps

  field :week_day,                       type: Integer
  field :time_from,                      type: Time
  field :time_to,                        type: Time

  embedded_in :room,                    class_name: 'Room'
end
