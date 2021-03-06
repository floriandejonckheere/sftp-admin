# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_07_20_164822) do

  create_table "keys", force: :cascade do |t|
    t.string "title", null: false
    t.string "key", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_keys_on_user_id"
  end

  create_table "shares", force: :cascade do |t|
    t.string "name", null: false
    t.string "path", null: false
    t.integer "size", default: 0, null: false
    t.integer "quota", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["path"], name: "index_shares_on_path", unique: true
  end

  create_table "shares_users", id: false, force: :cascade do |t|
    t.integer "share_id", null: false
    t.integer "user_id", null: false
    t.index ["share_id"], name: "index_shares_users_on_share_id"
    t.index ["user_id"], name: "index_shares_users_on_user_id"
    t.index [nil, nil], name: "index_shares_users_on_share_and_user", unique: true
    t.index [nil, nil], name: "index_shares_users_on_user_and_share", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_users_on_name", unique: true
  end

end
