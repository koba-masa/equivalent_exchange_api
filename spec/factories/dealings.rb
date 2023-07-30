# frozen_string_literal: true

FactoryBot.define do
  factory :dealing do
    applicant { nil }
    want { nil }
    stock { nil }
    dealing { nil }
    status { 20 }
  end
end
