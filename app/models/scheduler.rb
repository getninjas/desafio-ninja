class Scheduler < ApplicationRecord
  belongs_to :room
  has_and_belongs_to_many :employees

  validates_presence_of :start_meeting_time, :end_meeting_time, :meeting_description, :room_id, message: "Can't be blank"
  validates :start_meeting_time, :end_meeting_time, uniqueness: { scope: :room_id }, message: "Time interval already in use to this room"
end
