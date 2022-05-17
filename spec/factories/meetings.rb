FactoryBot.define do
  factory :meeting do
    start_time { '2022-05-16T14:41:02.827Z' }
    end_time { '2022-05-16T15:11:02.827Z' }
    subject { 'Planning' }
    room
    user
  end
end
