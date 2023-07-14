# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

if Rails.env.development?

  Stock.destroy_all
  Want.destroy_all
  Character.destroy_all
  Good.destroy_all
  Category.destroy_all
  User.destroy_all

  category1 = Category.create(name: 'ヘブンバーンズレッド')
  good11 = Good.create(category: category1, name: 'GIGO フォト風カード')
  character111 = Character.create(good: good11, name: '茅森月歌')
  character112 = Character.create(good: good11, name: '和泉ユキ')
  character113 = Character.create(good: good11, name: '逢川めぐみ')
  character114 = Character.create(good: good11, name: '東城つかさ')
  character115 = Character.create(good: good11, name: '朝倉可憐')
  character116 = Character.create(good: good11, name: '國見タマ')

  good12 = Good.create(category: category1, name: 'トレーディングアクリルネームプレート ver.A')
  Character.create(good: good12, name: '茅森月歌')
  Character.create(good: good12, name: '和泉ユキ')
  Character.create(good: good12, name: '逢川めぐみ')
  Character.create(good: good12, name: '東城つかさ')
  Character.create(good: good12, name: '朝倉可憐')
  Character.create(good: good12, name: '國見タマ')
  Character.create(good: good12, name: '二階堂三郷')
  Character.create(good: good12, name: '石井色葉')
  Character.create(good: good12, name: '命吹雪')
  Character.create(good: good12, name: '室伏理沙')
  Character.create(good: good12, name: '伊達朱里')
  Character.create(good: good12, name: '瑞原あいな')

  category2 = Category.create(name: 'DEATH STRANDING')
  good21 = Good.create(category: category2, name: 'Qpid メタルチャーム')
  Character.create(good: good21, name: 'A')
  Character.create(good: good21, name: 'B')
  Character.create(good: good21, name: 'C')
  Character.create(good: good21, name: 'D')
  Character.create(good: good21, name: 'E')
  Character.create(good: good21, name: 'F')

  good22 = Good.create(category: category2, name: 'BBPOD フィギュアマスコット')
  Character.create(good: good22, name: 'ノーマル')
  Character.create(good: good22, name: '空(BB付属無し)')
  Character.create(good: good22, name: '自家中毒')
  Character.create(good: good22, name: '高ストレス')
  Character.create(good: good22, name: 'ビッグスVer(BB付属無し)')

  category3 = Category.create(name: 'ディズニー')
  good31 = Good.create(category: category3, name: 'ディズニーキャラクター シークレットストラップ 風鈴風')
  character311 = Character.create(good: good31, name: 'グーフィー')
  character312 = Character.create(good: good31, name: 'ドナルド')
  character313 = Character.create(good: good31, name: 'プルート')
  character314 = Character.create(good: good31, name: 'ベイマックス')
  Character.create(good: good31, name: 'プーさん')
  Character.create(good: good31, name: 'スティッチ')

  good32 = Good.create(category: category3, name: 'ミッキー＆フレンズ シークレットチャーム つながる 気球 Disney Store Japan 30th Anniversary')
  character321 = Character.create(good: good32, name: 'ミッキー')
  character322 = Character.create(good: good32, name: 'ミニー')
  character323 = Character.create(good: good32, name: 'ドナルド')
  character324 = Character.create(good: good32, name: 'ディジー')
  Character.create(good: good32, name: 'グーフィー')
  character326 = Character.create(good: good32, name: 'プルート')

  user1 = User.create(login_id: 'testuser1', password: '#eDcVfR4', password_confirmation: '#eDcVfR4',
                      display_name: 'testuser1', email: 'testuser1@example.com')
  Want.create(user: user1, character: character111)
  Want.create(user: user1, character: character114)
  Stock.create(user: user1, character: character112, image: 'sample.png')
  Stock.create(user: user1, character: character113, image: 'sample.png')
  Stock.create(user: user1, character: character113, image: 'sample.png')

  user2 = User.create(login_id: 'testuser2', password: '#eDcVfR4', password_confirmation: '#eDcVfR4',
                      display_name: 'testuser2', email: 'testuser2@example.com')
  Want.create(user: user2, character: character115)
  Stock.create(user: user2, character: character114, image: 'sample.png')

  Want.create(user: user2, character: character312)
  Want.create(user: user2, character: character313)
  Want.create(user: user2, character: character313)
  Stock.create(user: user2, character: character311, image: 'sample.png')
  Stock.create(user: user2, character: character314, image: 'sample.png')

  Want.create(user: user2, character: character323)
  Want.create(user: user2, character: character326)
  Want.create(user: user2, character: character326)
  Stock.create(user: user2, character: character321, image: 'sample.png')
  Stock.create(user: user2, character: character322, image: 'sample.png')

  user3 = User.create(login_id: 'testuser3', password: '#eDcVfR4', password_confirmation: '#eDcVfR4',
                      display_name: 'testuser3', email: 'testuser3@example.com')
  Want.create(user: user3, character: character112)
  Want.create(user: user3, character: character116)
  Stock.create(user: user3, character: character111, image: 'sample.png')

  Want.create(user: user2, character: character323)
  Want.create(user: user3, character: character321)
  Want.create(user: user3, character: character326)
  Stock.create(user: user3, character: character321, image: 'sample.png')
  Stock.create(user: user3, character: character324, image: 'sample.png')
end
