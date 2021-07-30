class Schedule < ApplicationRecord
  belongs_to :room

  validates :scheduled_by, presence: true
  validates :start_at, presence: true
  validates :end_at, presence: true
end
