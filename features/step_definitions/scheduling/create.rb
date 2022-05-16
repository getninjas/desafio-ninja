Given('uma sala com horario disponivel') do
  @meeting_room = MeetingRoom.create(name: 'Sala 1')
end

When('uma solicitação é realizada para o agendamento') do
  scheduling_params = {
    meeting_room_id: 1,
    time: DateTime.current.tomorrow,
    responsible: "Nathan"
  }

  @response = Schedulings::CreateService.call(scheduling_params: scheduling_params)
end

Then('a sala fica reservada para aquele horario') do
  @response.success?
end