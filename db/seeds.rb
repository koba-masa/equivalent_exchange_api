# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Stock.destroy_all
Want.destroy_all
Character.destroy_all
Good.destroy_all
Category.destroy_all
User.destroy_all
User.create!(
  [
    { login_id: 'testuser1', password: 'test123', password_confirmation: 'test123', display_name: 'testuser1',
      email: 'testuser1@example.com' },
    { login_id: 'testuser2', password: 'test123', password_confirmation: 'test123', display_name: 'testuser2',
      email: 'testuser2@example.com' },
    { login_id: 'testuser3', password: 'test123', password_confirmation: 'test123', display_name: 'testuser3',
      email: 'testuser3@example.com' },
  ],
)

test_matching_data = Rails.root.join('db/seeds/test_matching_data.rb')
require test_matching_data if File.exist?(test_matching_data)
