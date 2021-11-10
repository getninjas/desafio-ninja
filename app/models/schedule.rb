class Schedule < ApplicationRecord
  belongs_to :user
  belongs_to :room

  has_and_belongs_to_many :guests
end
