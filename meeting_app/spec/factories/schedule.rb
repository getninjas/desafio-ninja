# frozen_string_literal: true

FactoryBot.define do
  factory :schedule do
    title      { random_string }
    date       { Date.today + rand(100) }
    start_hour { rand(1..11) }
    end_hour   { rand(12..23) }
    room_id    { create(:room).id }
  end
end
