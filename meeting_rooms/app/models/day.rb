class Day
  include Mongoid::Document
  include Mongoid::Timestamps

  field :weekDay,                       type: Integer
  field :timeFrom,                      type: Time
  field :timeTo,                        type: Time
end
