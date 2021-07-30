FactoryBot.define do
  factory :schedule do
    room
    scheduled_by { Faker::Name.name }
    start_at { Faker::Time.between_dates(from: Date.today, to: Date.today + rand(1..7), period: :afternoon) }
    end_at { start_at + rand(1..2).hour }
  end
end
