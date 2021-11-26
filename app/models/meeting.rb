class Meeting < ApplicationRecord
  include ActiveModel::Validations

  belongs_to :room
  validate :meeting_duration
  validates_with Validations::BusinessHours

  def meeting_duration
    if starts_at && ends_at
      errors.add(:ends_at, "must be greater than starts_at") if starts_at >= ends_at
    end
  end
end
