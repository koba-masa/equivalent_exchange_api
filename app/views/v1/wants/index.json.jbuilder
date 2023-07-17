# frozen_string_literal: true

json.wants @wants do |want|
  json.category_name want.character.good.category.name
  json.good_name want.character.good.name
  json.character_name want.character.name
  json.id want.id
  json.status want.status_label
end
