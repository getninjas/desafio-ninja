class Scheduling
  include Mongoid::Document
  include Mongoid::Timestamps

  field :date,                          type: Date
  field :time,                          type: Time
end
