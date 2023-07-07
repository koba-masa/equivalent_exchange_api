# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    login_id { 'test_user' }
    password { 'password' }
    display_name { 'テストユーザー' }
    email { 'testuser@sample.com' }
  end
end
