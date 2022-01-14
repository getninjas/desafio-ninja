class SchedulingsController < ApplicationController
  before_action :set_scheduling, only: %i[show update destroy]
  before_action :set_room, only: %i[show update destroy create]

  # GET /schedulings
  # GET /schedulings.json
  def index
    @schedulings = Scheduling.all
  end

  # GET /schedulings/1
  # GET /schedulings/1.json
  def show
    # show method
  end

  # POST /schedulings
  # POST /schedulings.json
  def create
    @scheduling = Scheduling.new(scheduling_params.merge(room_id: @room&.id))

    if @scheduling.save
      render :show, status: :created, location: room_schedulings_path(@scheduling)
    else
      render json: @scheduling.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /schedulings/1
  # PATCH/PUT /schedulings/1.json
  def update
    if @scheduling.update(scheduling_params)
      render :show, status: :ok, location: room_schedulings_path(@scheduling)
    else
      render json: @scheduling.errors, status: :unprocessable_entity
    end
  end

  # DELETE /schedulings/1
  # DELETE /schedulings/1.json
  def destroy
    @scheduling.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_scheduling
    @scheduling = Scheduling.find(params[:id])
  end

  def set_room
    @room = Room.find(params[:room_id])
  end

  # Only allow a list of trusted parameters through.
  def scheduling_params
    params.permit(:date, :time, :duration)
  end
end
