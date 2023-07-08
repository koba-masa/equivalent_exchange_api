# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:login_id){|n| "test_user_#{n}"}
    password { 'password' }
    display_name { 'テストユーザー' }
    sequence(:email){|n| "testuser_#{n}@sample.com"}
  end
end
