# frozen_string_literal: true

class Room < ActiveRecord::Base

  has_many :schedules

end
