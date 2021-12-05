FactoryBot.define do
  factory :room do
    name {"Sala de reunião"}
    organization factory: :organization
  end
end