FactoryBot.define do
  factory :schedule do
    room
    user
    start_time { DateTime.now }
    end_time { 1.hour.from_now.to_datetime }
  end
end
