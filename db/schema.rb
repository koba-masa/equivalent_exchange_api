# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_07_14_150938) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "categories", comment: "カテゴリ", force: :cascade do |t|
    t.string "name", limit: 128, null: false, comment: "カテゴリ名"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_categories_on_name", unique: true
  end

  create_table "characters", comment: "キャラクター", force: :cascade do |t|
    t.bigint "good_id", null: false, comment: "商品"
    t.string "name", limit: 128, null: false, comment: "キャラクター名"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["good_id", "name"], name: "index_characters_on_good_id_and_name", unique: true
    t.index ["good_id"], name: "index_characters_on_good_id"
  end

  create_table "goods", comment: "商品", force: :cascade do |t|
    t.bigint "category_id", null: false, comment: "カテゴリ"
    t.string "name", limit: 128, null: false, comment: "商品名"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id", "name"], name: "index_goods_on_category_id_and_name", unique: true
    t.index ["category_id"], name: "index_goods_on_category_id"
  end

  create_table "stocks", comment: "在庫", force: :cascade do |t|
    t.uuid "user_id", null: false, comment: "ユーザー"
    t.bigint "character_id", null: false, comment: "キャラクター"
    t.integer "status", limit: 2, default: 0, null: false, comment: "ステータス"
    t.string "image", limit: 128, null: false, comment: "画像ファイル名"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id"], name: "index_stocks_on_character_id"
    t.index ["user_id"], name: "index_stocks_on_user_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, comment: "ユーザー", force: :cascade do |t|
    t.string "login_id", null: false, comment: "ログインID"
    t.string "password_digest", null: false, comment: "パスワード"
    t.string "display_name", null: false, comment: "表示名"
    t.string "email", null: false, comment: "メールアドレス"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["login_id"], name: "index_users_on_login_id", unique: true
  end

  create_table "wants", comment: "欲しいもの", force: :cascade do |t|
    t.uuid "user_id", null: false, comment: "ユーザー"
    t.bigint "character_id", null: false, comment: "キャラクター"
    t.integer "status", limit: 2, default: 0, null: false, comment: "ステータス"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id"], name: "index_wants_on_character_id"
    t.index ["user_id"], name: "index_wants_on_user_id"
  end

  add_foreign_key "characters", "goods"
  add_foreign_key "goods", "categories"
  add_foreign_key "stocks", "characters"
  add_foreign_key "stocks", "users"
  add_foreign_key "wants", "characters"
  add_foreign_key "wants", "users"

  create_view "v_characters", sql_definition: <<-SQL
      SELECT characters.id AS character_id,
      categories.name AS category_name,
      goods.name AS goods_name,
      characters.name AS character_name,
      categories.id AS category_id,
      goods.id AS good_id
     FROM ((characters
       JOIN goods ON ((characters.good_id = goods.id)))
       JOIN categories ON ((goods.category_id = categories.id)))
    ORDER BY categories.id, goods.id, characters.id;
  SQL
  create_view "v_wants", sql_definition: <<-SQL
      SELECT wants.id AS want_id,
      wants.user_id,
      v_characters.category_name,
      v_characters.goods_name,
      v_characters.character_name,
      wants.status,
      v_characters.category_id,
      v_characters.good_id,
      v_characters.character_id
     FROM (wants
       JOIN v_characters ON ((wants.character_id = v_characters.character_id)))
    ORDER BY wants.user_id, v_characters.category_id, v_characters.good_id, v_characters.character_id;
  SQL
  create_view "v_stocks", sql_definition: <<-SQL
      SELECT stocks.id AS stock_id,
      stocks.user_id,
      v_characters.category_name,
      v_characters.goods_name,
      v_characters.character_name,
      stocks.status,
      v_characters.category_id,
      v_characters.good_id,
      v_characters.character_id
     FROM (stocks
       JOIN v_characters ON ((stocks.character_id = v_characters.character_id)))
    ORDER BY stocks.user_id, v_characters.category_id, v_characters.good_id, v_characters.character_id;
  SQL
end
