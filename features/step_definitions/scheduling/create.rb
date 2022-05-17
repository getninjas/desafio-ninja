Given('uma sala de reunioes') do
  @meeting_room = MeetingRoom.create(name: 'Sala 1')
end

Given('dia e horarios permitidos') do
  @scheduling_params = {
    meeting_room_id: 1,
    time: DateTime.current.beginning_of_week.next_week.change(hour: 9),
    responsible: "Nathan"
  }
end

Given('em um horario ja agendado') do
  @scheduling_params = {
    meeting_room_id: 1,
    time: DateTime.current.beginning_of_week.next_week.change(hour: 9),
    responsible: "Nathan"
  }

  Schedulings::CreateService.call(scheduling_params: @scheduling_params)
end

When('uma solicitação é realizada para o agendamento') do
  @response = Schedulings::CreateService.call(scheduling_params: @scheduling_params)
end

Then('a sala fica reservada para aquele horario') do
  expect(@response.success?).to be true
end

Given('uma sala com horario ja agendado') do
  @meeting_room = MeetingRoom.create(name: 'Sala 1')

  scheduling_params = {
    meeting_room_id: 1,
    time: DateTime.current.tomorrow,
    responsible: "Nathan"
  }

  Schedulings::CreateService.call(scheduling_params: scheduling_params)
end

Then('a solicitação e recusada e uma mensagem de horario ja agendado é retornada') do
  expect(@response.success?).to be false
  expect(@response.error.first).to eq("#{I18n.t('activerecord.attributes.scheduling.time')} #{I18n.t('activerecord.errors.models.scheduling.attributes.time.taken')}")
end

Given('dia permitido e hoario nao permitido') do
  @scheduling_params = {
    meeting_room_id: 1,
    time: DateTime.current.beginning_of_week.next_week.change(hour: 19),
    responsible: "Nathan"
  }
end

Then('a solicitação e recusada e uma mensagem de horario fora do permitido é retornada') do
  expect(@response.success?).to be false
  expect(@response.error.first).to eq("#{I18n.t('activerecord.attributes.scheduling.time')} #{I18n.t('activerecord.errors.models.scheduling.attributes.time.out_of_time')}")
end