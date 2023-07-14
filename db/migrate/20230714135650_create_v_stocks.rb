# frozen_string_literal: true

class CreateVStocks < ActiveRecord::Migration[7.0]
  def change
    create_view :v_stocks
  end
end
