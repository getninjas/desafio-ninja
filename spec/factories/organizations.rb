FactoryBot.define do
  factory :organization do
    name {"GetNinjas São Paulo"}
    adress {"São Paulo-SP"}
    number_of_rooms {4}
    work_on_weekend {false}
    business_hours_start {"09:00"}
    business_hours_end {"18:00"}
  end
end

