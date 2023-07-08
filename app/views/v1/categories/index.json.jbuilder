# frozen_string_literal: true

json.categories @categories do |category|
  json.id category.id
  json.name category.name
end
