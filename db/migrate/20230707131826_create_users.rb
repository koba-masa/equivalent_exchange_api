# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')
    create_table :users, id: :uuid, comment: 'ユーザー' do |t|
      t.string :login_id, null: false, length: 128, comment: 'ログインID'
      t.string :password_digest, null: false, comment: 'パスワード'
      t.string :display_name, null: false, length: 128, comment: '表示名'
      t.string :email, null: false, length: 512, comment: 'メールアドレス'

      t.timestamps

      t.index :login_id, unique: true
      t.index :email, unique: true
    end
  end
end
