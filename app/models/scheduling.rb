class Scheduling < ApplicationRecord
  include SchedulingTimeRules

  belongs_to :meeting_room

  validate :valid_time_range, if: -> { time.present? }
  validate :valid_time_unique, if: -> { time.present? }

  before_validation :format_hour

end
