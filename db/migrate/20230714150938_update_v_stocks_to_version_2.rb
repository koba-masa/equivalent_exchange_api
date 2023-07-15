# frozen_string_literal: true

class UpdateVStocksToVersion2 < ActiveRecord::Migration[7.0]
  def change
    update_view :v_stocks, version: 2, revert_to_version: 1
  end
end
