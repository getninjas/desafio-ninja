FactoryBot.define do
  factory :meeting do
    start_time { "2022-05-14 00:49:05" }
    end_time { "2022-05-14 00:49:05" }
    room { nil }
    user { nil }
    subject { "MyString" }
  end
end
