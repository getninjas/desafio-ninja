FactoryBot.define do
  factory :meeting do
    starts_at {"Mon, 06 Dec 2021 10:00"}
    end_at {"Mon, 06 Dec 2021 11:00"}
    room factory: :room
  end
end
