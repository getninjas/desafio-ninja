class SchedulingsController < ApiController
  def index
    render_success(Scheduling.all.where('time > ?', DateTime.current.beginning_of_day))
  end
  
  def create
    scheduling = Schedulings::CreateService.call(scheduling_params: scheduling_params)

    return render_created(scheduling.result) if scheduling.success?

    render_unprocessable_entity(scheduling.error)
  end

  private

  def scheduling_params
    params.permit(:meeting_room_id, :time, :responsible)
  end
end
