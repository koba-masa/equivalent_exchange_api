# frozen_string_literal: true

class UpdateVMatchingsToVersion2 < ActiveRecord::Migration[7.0]
  def change
    update_view :v_matchings, version: 2, revert_to_version: 1
  end
end
