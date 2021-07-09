class Room < ActiveRecord::Base
  # Associations
  has_many :appointments

  # Validations
  validates :name, presence: true
  validates :availability_days, presence: true
  validates :availability_start_time, presence: true, hour_string_format: true
  validates :availability_end_time, presence: true, hour_string_format: true
end