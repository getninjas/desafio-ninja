class Scheduler < ApplicationRecord
  belongs_to :room
  has_and_belongs_to_many :employees
end
