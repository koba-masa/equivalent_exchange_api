# frozen_string_literal: true

FactoryBot.define do
  factory :dealing do
    applicant_want { nil }
    partner_stock { nil }
    partner_want { nil }
    applicant_stock { nil }
    status { 20 }
  end
end
