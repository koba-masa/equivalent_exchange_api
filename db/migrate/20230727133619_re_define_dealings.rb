# frozen_string_literal: true

class ReDefineDealings < ActiveRecord::Migration[7.0]
  def up
    drop_table :dealings
    create_table :dealings, comment: '取引履歴' do |t|
      t.references :applicant, type: :uuid, null: false, foreign_key: { to_table: :users }, comment: '申請者'
      t.references :want, null: false, foreign_key: true, comment: '欲しいもの'
      t.references :stock, null: false, foreign_key: true, comment: '在庫'
      t.references :dealing, null: true, foreign_key: true, comment: '取引履歴'
      t.integer :status, null: false, default: 20, comment: 'ステータス'

      t.timestamps
    end
  end

  def down
    drop_table :dealings
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
