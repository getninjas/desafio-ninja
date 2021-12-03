class Meeting < ApplicationRecord
  belongs_to :room

  validates :room_id,:starts_at, :end_at, presence: true

  validate :end_greater_start, :booking_conflict

  def end_greater_start
    if starts_at >= end_at
      errors.add(:end_at, 'Horário de fim de reunião deve ser maior que horário inicial')
    else
      true
    end
  end

  def booking_conflict
    meetings_in_room = Meeting.where(room_id: room_id).where.not(id: id)
    conflicts = []
    duration = (starts_at..end_at)
    meetings_in_room.each do |meeting|
      conflicts << meeting if duration.overlaps?(meeting.starts_at..meeting.end_at)
    end

    

    if conflicts.present?
      message = "Sala já reservada na reunião com ID #{conflicts.pluck(:id)}"
      errors.add(:starts_at, message )
    else
      true
    end
  end
end
