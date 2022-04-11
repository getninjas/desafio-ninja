# frozen_string_literal: true

class Room < ActiveRecord::Base

  has_many :schedules

  validates :name, presence: true, uniqueness: true

end
