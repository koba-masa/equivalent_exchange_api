# frozen_string_literal: true

class CreateVCharacters < ActiveRecord::Migration[7.0]
  def change
    create_view :v_characters
  end
end
