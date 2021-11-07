FactoryBot.define do
  factory :room do
    sequence :name do |n|
      "Room##{n}"
    end
  end
end
