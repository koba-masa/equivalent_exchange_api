# frozen_string_literal: true

class CreateWants < ActiveRecord::Migration[7.0]
  def change
    create_table :wants, comment: '欲しいもの' do |t|
      t.references :user, type: :uuid, null: false, foreign_key: true, comment: 'ユーザー'
      t.references :character, null: false, foreign_key: true, comment: 'キャラクター'
      t.integer :status, null: false, default: 0, limit: 1, comment: 'ステータス'

      t.timestamps
    end
  end
end
