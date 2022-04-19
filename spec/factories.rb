FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    name { Faker::Name.name }
    password { '12345678' }
    password_confirmation { '12345678' }
  end

  factory :room do
    number { rand(1..1000) }
    description { "Sala para reuniões" }
  end

  factory :schedule do
    datetime = DateTime.current + 1.day
    while datetime.saturday? || datetime.sunday?
      datetime = DateTime.current + 1.day
    end

    room { create(:room) }
    user { create(:user) }
    start_time { DateTime.new(datetime.year, datetime.month, datetime.day, 16, 0, 0) }
    end_time { DateTime.new(datetime.year, datetime.month, datetime.day, 17, 0, 0) }
  end
end