FactoryBot.define do
  factory :guest do
    email { Faker::Internet.email }
  end
end
