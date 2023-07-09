# frozen_string_literal: true

FactoryBot.define do
  factory :want do
    user
    character
    status { 0 }

    trait :canceled do
      status { 10 }
    end

    trait :trading do
      status { 20 }
    end

    trait :traded do
      status { 30 }
    end
  end
end
