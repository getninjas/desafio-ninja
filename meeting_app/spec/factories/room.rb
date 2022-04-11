# frozen_string_literal: true

FactoryBot.define do
  factory :room do
    name { random_string }
  end
end
