# frozen_string_literal: true

class AddColumnTradingIdToTradings < ActiveRecord::Migration[7.0]
  def change
    add_reference :tradings, :trading, null: true, foreign_key: true, comment: '交換'
  end
end
