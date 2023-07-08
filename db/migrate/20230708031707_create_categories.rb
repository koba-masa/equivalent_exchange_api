# frozen_string_literal: true

class CreateCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :categories, comment: 'カテゴリ' do |t|
      t.string :name, null: false, limit: 128, comment: 'カテゴリ名'

      t.timestamps

      t.index :name, unique: true
    end
  end
end
