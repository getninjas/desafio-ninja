FactoryBot.define do
  factory :room do
    name { Faker::Color.color_name.capitalize }
  end
end
