class Appointment < ActiveRecord::Base
  # Associations
  belongs_to :room

  # Validations
  validates :responsible_name, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :room, presence: true
end