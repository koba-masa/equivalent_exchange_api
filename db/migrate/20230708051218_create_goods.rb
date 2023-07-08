# frozen_string_literal: true

class CreateGoods < ActiveRecord::Migration[7.0]
  def change
    create_table :goods, comment: '商品' do |t|
      t.references :category, null: false, foreign_key: true, comment: 'カテゴリ'
      t.string :name, null: false, limit: 128, comment: '商品名'

      t.timestamps

      t.index %i[category_id name], unique: true
    end
  end
end
