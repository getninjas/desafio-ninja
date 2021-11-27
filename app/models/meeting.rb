class Meeting < ApplicationRecord
  include ActiveModel::Validations

  belongs_to :room

  validates :starts_at, :ends_at, presence: true
  validate :meeting_duration, :meeting_conflict
  validates_with Validations::BusinessHours

  def meeting_duration
    if starts_at && ends_at
      errors.add(:ends_at, "must be greater than starts_at") if starts_at >= ends_at
    end
  end

  def period
    starts_at..ends_at
  end
  
  def meeting_conflict
    other_meetings = Meeting.where(room_id: room_id).where.not(id: id)

    is_overlapping = other_meetings.any? do |other_meeting|
      period.overlaps?(other_meeting.period)
    end

    errors.add(:room_already_reserved, "meeting period was already reserved") if is_overlapping
  end
end

