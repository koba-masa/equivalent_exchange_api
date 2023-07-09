# frozen_string_literal: true

json.category_name @want.character.good.category.name
json.good_name @want.character.good.name
json.character_name @want.character.name
json.id @want.id
json.status @want.status_label
json.stocks @want.candidate_stocks do |stock|
  json.id stock.id
  json.user_name stock.user.display_name
  json.status stock.status_label
  json.image stock.image_url
end
