# frozen_string_literal: true

FactoryBot.define do
  factory :character do
    good
    sequence(:name) { |n| "キャラクター#{n}" }
  end
end
