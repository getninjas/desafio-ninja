class DeleteSchedule
  include ActiveModel::Model

  def perform(id)
    schedule = Schedule.find(id)
    schedule.delete
  end
end
