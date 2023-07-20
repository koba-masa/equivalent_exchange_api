# frozen_string_literal: true

class UpdateVStocksToVersion3 < ActiveRecord::Migration[7.0]
  def up
    drop_view :v_matchings
    update_view :v_stocks, version: 3
    create_view :v_matchings, version: 2
  end

  def down
    drop_view :v_matchings
    update_view :v_stocks, version: 2
    create_view :v_matchings, version: 2
  end
end
