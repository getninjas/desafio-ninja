class Room
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :schedulings,                class_name: 'Scheduling'
  embeds_many :days,                    class_name: 'Day'
end
