FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::App.name }
  end
end
