class SchedulingsController < ApplicationController
  before_action :set_scheduling, only: %i[show update destroy]

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
    @scheduling = Scheduling.new(scheduling_params)

    if @scheduling.save
      render :show, status: :created, location: @scheduling
    else
      render json: @scheduling.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /schedulings/1
  # PATCH/PUT /schedulings/1.json
  def update
    if @scheduling.update(scheduling_params)
      render :show, status: :ok, location: @scheduling
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

  # Only allow a list of trusted parameters through.
  def scheduling_params
    params.fetch(:scheduling, {})
  end
end
