FactoryBot.define do
  factory :schedule do
    room { nil }
    scheduled_by { Faker::Name.name }
    start_at { DateTime.now.beginning_of_day + 9.hour }
    end_at { start_at + 1.hour }
  end
end
