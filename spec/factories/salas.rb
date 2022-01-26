FactoryBot.define do
  factory :sala do
    nome { FFaker::Name.name }

    trait :com_agenda do
      after(:build) do |instance|
        instance.agenda = build(:agenda)
      end
    end
  end
end
