# frozen_string_literal: true

FactoryBot.define do
  factory :stock do
    user
    character
    status { 0 }
    image { 'sample.png' }
  end
end
