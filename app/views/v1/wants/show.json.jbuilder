# frozen_string_literal: true

json.category_name @want.character.good.category.name
json.good_name @want.character.good.name
json.character_name @want.character.name
json.id @want.id
json.status @want.status_label
json.candidates @candidates do |candidate|
  json.stock_id candidate.your_stock_id
  json.user_name candidate.your_user_name
  json.image candidate.image_url
  json.your_want_id candidate.your_want_id
  json.your_want_character_name candidate.your_want_character_name
end
