# frozen_string_literal: true

json.stocks @stocks do |stock|
  json.category_name stock.character.good.category.name
  json.good_name stock.character.good.name
  json.character_name stock.character.name
  json.id stock.id
  json.status stock.status_label
  json.image stock.image_url
end
