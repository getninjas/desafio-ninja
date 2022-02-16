class Room < ApplicationRecord
  has_many :schedulers

  validates_presence_of :name, :open_at, :close_at, :people_limit_by_meeting, :time_limit_by_meeting, message: "can't be blank"
  validates_uniqueness_of :name, message: "must be unique"
end
