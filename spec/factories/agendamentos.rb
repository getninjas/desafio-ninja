FactoryBot.define do
  factory :agendamento do
    data { Date.current }
    horario_inicio { Time.current }
    horario_final { Time.current + 1.minutes}
  end
end
