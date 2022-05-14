class Room < ApplicationRecord
  validates :name, uniqueness: true

  has_many :meetings
end
