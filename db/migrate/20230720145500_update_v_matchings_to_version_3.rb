# frozen_string_literal: true

class UpdateVMatchingsToVersion3 < ActiveRecord::Migration[7.0]
  def change
    update_view :v_matchings, version: 3, revert_to_version: 2
  end
end
