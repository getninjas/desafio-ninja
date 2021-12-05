class Organization < ApplicationRecord
  has_many :rooms

  validates :name, :number_of_rooms, :business_hours_start, :business_hours_end, presence: true

end
