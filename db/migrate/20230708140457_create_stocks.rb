# frozen_string_literal: true

class CreateStocks < ActiveRecord::Migration[7.0]
  def change
    create_table :stocks, comment: '在庫' do |t|
      t.references :user, type: :uuid, null: false, foreign_key: true, comment: 'ユーザー'
      t.references :character, null: false, foreign_key: true, comment: 'キャラクター'
      t.integer :status, null: false, default: 0, limit: 1, comment: 'ステータス'
      t.string :image, null: false, limit: 128, comment: '画像ファイル名'

      t.timestamps
    end
  end
end
