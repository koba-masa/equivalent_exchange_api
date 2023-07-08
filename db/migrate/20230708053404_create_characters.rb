# frozen_string_literal: true

class CreateCharacters < ActiveRecord::Migration[7.0]
  def change
    create_table :characters, comment: 'キャラクター' do |t|
      t.references :good, null: false, foreign_key: true, comment: '商品'
      t.string :name, null: false, limit: 128, comment: 'キャラクター名'

      t.timestamps

      t.index %i[good_id name], unique: true
    end
  end
end
