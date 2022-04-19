FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    name { Faker::Name.name}
    password  { '12345678' }
    password_confirmation  { '12345678' }
  end

  factory :room do
    number { rand(1..1000) }
    description { "Sala para reuniões" }
  end
end