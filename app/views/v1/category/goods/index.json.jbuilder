# frozen_string_literal: true

json.goods @goods do |good|
  json.category_id good.category.id
  json.category_name good.category.name
  json.id good.id
  json.name good.name
end
