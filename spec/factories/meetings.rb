FactoryBot.define do
  factory :meeting do
    start_time { '2022-05-16 00:49:05' }
    end_time { '2022-05-16 00:49:05' }
    subject { 'Planning' }
    room
    user
  end
end
