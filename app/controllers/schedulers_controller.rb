class SchedulersController < ApplicationController
  before_action :set_scheduler, only: [:show, :update, :destroy]

  # GET /schedulers
  def index
    @schedulers = Scheduler.all

    render json: @schedulers
  end

  # GET /schedulers/1
  def show
    render json: @scheduler
  end

  # POST /schedulers
  def create
    @scheduler = Scheduler.new(scheduler_params)
    scheduled_room_people_limit = @scheduler.room.people_limit

    if @employees_ids.count > scheduled_room_people_limit
      @scheduler.errors.add(:people_limit, "The people limit for this room is #{scheduled_room_people_limit}") 
    end

    if @scheduler.start_meeting_time.hour < @scheduler.room.open_at    
      @scheduler.errors.add(:start_meeting_time, "Please check when this room will be opened")
    end

    if @scheduler.end_meeting_time.hour > @scheduler.room.close_at
      @scheduler.errors.add(:end_meeting_time, "Please check when this room will be closed")
    end

    employees_validator

    if @scheduler.save
      render json: @scheduler, status: :created, location: @scheduler
    else
      render json: @scheduler.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /schedulers/1
  def update
    employees_validator
    
    if @scheduler.update(scheduler_params.except(:room_id, :start_meeting_time, :end_meeting_time))
      render json: @scheduler
    else
      render json: @scheduler.errors, status: :unprocessable_entity
    end
  end

  # DELETE /schedulers/1
  def destroy
    if DateTime.now > @scheduler.start_meeting_time
      @scheduler.errors.add(:start_meeting_time, "This meeting already started")
      render json: @scheduler.errors, status: :unprocessable_entity
    else
      @scheduler.destroy
    end
  end

  private

    def employees_validator
      employees = Employee.where(id: @employees_ids) 

      employees.each do |employee|
        already_in_a_meeting = Scheduler
                                .where(
                                  employee_id: employee.id
                                )
                                .where(
                                  start_meeting_time: @scheduler.start_meeting_time..@scheduler.end_meeting_time
                                )
                                .or(
                                  end_meeting_time: @scheduler.start_meeting_time..@scheduler.end_meeting_time
                                )

        if already_in_a_meeting     
          @scheduler.errors.add(:employee_id, "#{employee.name} already is in a meeting in this time interval: #{already_in_a_meeting.meeting_description}") 
        end
      end

      @scheduler.employees = employees
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_scheduler
      @scheduler = Scheduler.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def scheduler_params
      params.require(:scheduler).permit(:start_meeting_time, :end_meeting_time, :meeting_description, :room_id)
    end
end
