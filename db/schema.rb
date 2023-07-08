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

ActiveRecord::Schema[7.0].define(version: 2023_07_08_053404) do
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

  add_foreign_key "characters", "goods"
  add_foreign_key "goods", "categories"
end
