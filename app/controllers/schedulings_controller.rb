class SchedulingsController < ApiController
  before_action :find_scheduling, only: [:update, :show]

  def index
    render_success(Scheduling.all.where('time > ?', DateTime.current.beginning_of_day))
  end
  
  def create
    scheduling = Schedulings::CreateService.call(scheduling_params: scheduling_params)

    return render_created(scheduling.result) if scheduling.success?

    render_unprocessable_entity(scheduling.error)
  end

  def update
    scheduling = Schedulings::UpdateService.call(scheduling_params: scheduling_params, scheduling: @scheduling)

    return render_success(scheduling.result) if scheduling.success?

    render_unprocessable_entity(scheduling.error)
  end

  def show
    render_success(@scheduling)
  end

  private

  def scheduling_params
    params.permit(:meeting_room_id, :time, :responsible)
  end

  def find_scheduling
    @scheduling = Scheduling.find(params[:id])
  end
end
