# frozen_string_literal: true

class CreateDealings < ActiveRecord::Migration[7.0]
  def change
    create_table :dealings, comment: '取引履歴' do |t|
      t.references :applicant_want, null: false, foreign_key: { to_table: :wants }, comment: '申請者の欲しいもの'
      t.references :partner_stock, null: false, foreign_key: { to_table: :stocks }, comment: '相手の在庫'
      t.references :partner_want, null: false, foreign_key: { to_table: :wants }, comment: '相手の欲しいもの'
      t.references :applicant_stock, null: false, foreign_key: { to_table: :stocks }, comment: '申請者の在庫'
      t.integer :status, null: false, default: 20, comment: 'ステータス'

      t.timestamps
    end
  end
end
