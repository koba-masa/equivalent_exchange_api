# frozen_string_literal: true

FactoryBot.define do
  factory :trading do
    want
    stock
    status { 20 }

    trait :trading do
      status { 20 }
    end

    trait :traded do
      status { 30 }
    end
  end
end
