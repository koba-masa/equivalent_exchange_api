# frozen_string_literal: true

class CreateVWants < ActiveRecord::Migration[7.0]
  def change
    create_view :v_wants
  end
end
