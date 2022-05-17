Given('um agendamento') do
  scheduling_params = {
    meeting_room_id: 1,
    time: DateTime.current.beginning_of_week.next_week.change(hour: 10),
    responsible: "Nathan"
  }

  @scheduling = Schedulings::CreateService.call(scheduling_params: scheduling_params).result
end

When('uma solicitação é realizada para atualizar o agendamento') do
  @response = Schedulings::UpdateService.call(scheduling_params: @scheduling_params, scheduling: @scheduling)
end