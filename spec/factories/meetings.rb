FactoryBot.define do
  factory :meetings do
    title { "Spring Review - Squad" }
    starts_at { "2021-11-25 21:19:15" }
    ends_at { "2021-11-25 21:19:15" }
    room { create(:room) }
  end
end
