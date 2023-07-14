# frozen_string_literal: true

class CreateVMatchings < ActiveRecord::Migration[7.0]
  def change
    create_view :v_matchings
  end
end
