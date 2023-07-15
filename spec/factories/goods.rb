# frozen_string_literal: true

FactoryBot.define do
  factory :good do
    category
    sequence(:name) { |n| "商品#{n}" }
  end
end
