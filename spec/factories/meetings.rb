FactoryBot.define do
  factory :meeting do
    title { "Spring Review - Squad" }
    starts_at { "2021-11-25 09:00:00" }
    ends_at { "2021-11-25 10:00:00" }
    room { create(:room) }
  end
end
