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

    scheduled_room_people_limit = @scheduler.room.people_limit_by_meeting

    if employees_ids.count > scheduled_room_people_limit
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
    
    if @scheduler.update(scheduler_params.except(:start_meeting_time, :end_meeting_time))
      render json: @scheduler
    else
      render json: @scheduler.errors, status: :unprocessable_entity
    end
  end

  # DELETE /schedulers/1
  def destroy
    if DateTime.now > @scheduler.start_meeting_time
      @scheduler.errors.add(:start_meeting_time, "This meeting already started or finalized")
      render json: @scheduler.errors, status: :unprocessable_entity
    else
      @scheduler.destroy
    end
  end

  private

    def employees_validator
      employees = Employee.where(id: employees_ids) 

      employees.each do |employee|
        already_in_a_meeting = Scheduler
                                .where(
                                  employee_id: employee.id,
                                  start_meeting_time: @scheduler.start_meeting_time..@scheduler.end_meeting_time
                                ).or(
                                  Scheduler.where(employee_id: employee.id, end_meeting_time: @scheduler.start_meeting_time..@scheduler.end_meeting_time)
                                )
                              
        if already_in_a_meeting     
          @scheduler.errors.add(:employee_id, "#{employee.name} already is in a meeting between this time") 
        end
      end

      employees_ids.each do |employee_id|
        EmployeeScheduler.create(employee_id: employee_id, scheduler_id: @scheduler.id)
      end
    end

    def employees_ids
      params[:scheduler][:employees_ids]
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_scheduler
      @scheduler = Scheduler.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def scheduler_params
      params.require(:scheduler).permit(:room_id, :start_meeting_time, :end_meeting_time, :meeting_description)
    end
end
