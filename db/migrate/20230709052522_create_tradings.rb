# frozen_string_literal: true

class CreateTradings < ActiveRecord::Migration[7.0]
  def change
    create_table :tradings, comment: '交換' do |t|
      t.references :want, null: false, foreign_key: true, comment: '欲しいもの'
      t.references :stock, null: false, foreign_key: true, comment: '在庫'
      t.integer :status, null: false, default: 20, comment: 'ステータス'

      t.timestamps
    end
  end
end
