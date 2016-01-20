# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160120211543) do

  create_table "cliqs", force: :cascade do |t|
    t.string   "perks_description"
    t.integer  "price"
    t.integer  "owner_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "cliqs_users", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "cliq_id"
  end

  create_table "downloads", force: :cascade do |t|
    t.integer  "song_id"
    t.integer  "clique_id"
    t.integer  "downloader_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "messages", force: :cascade do |t|
    t.string   "title"
    t.string   "description"
    t.integer  "from_id"
    t.integer  "to_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "songs", force: :cascade do |t|
    t.string   "url"
    t.integer  "price"
    t.integer  "owner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "streams", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "image"
    t.integer  "age"
    t.string   "gender"
    t.date     "birthday"
    t.string   "phone"
    t.integer  "type"
    t.string   "address"
    t.string   "city"
    t.string   "country"
    t.string   "email"
    t.string   "twitter_name"
    t.string   "soundcloud_name"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "provider"
    t.string   "uid"
    t.string   "encrypted_password"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0, null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true

end
