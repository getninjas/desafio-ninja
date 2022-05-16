class Scheduling < ApplicationRecord
  include SchedulingTimeRules

  belongs_to :meeting_room

  validate :valid_time_range
  validate :valid_time_unique

  before_validation :format_hour

end
