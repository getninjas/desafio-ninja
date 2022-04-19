class Room < ApplicationRecord
  validates :number, :description, presence: true, allow_nil: false
  validates :number, numericality: true, uniqueness: true

  has_many :schedules
end
