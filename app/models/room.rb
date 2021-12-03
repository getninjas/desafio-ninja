class Room < ApplicationRecord
  has_many :meetings
  belongs_to :organization
  validates :name, presence: true


end
