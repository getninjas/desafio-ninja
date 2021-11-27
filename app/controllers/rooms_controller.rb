# frozen_string_literal: true

class RoomsController < ApplicationController
  def index
    render json: Room.all
  end
end
