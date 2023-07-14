# frozen_string_literal: true

class UpdateVWantsToVersion2 < ActiveRecord::Migration[7.0]
  def change
    update_view :v_wants, version: 2, revert_to_version: 1
  end
end
