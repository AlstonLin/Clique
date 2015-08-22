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

ActiveRecord::Schema.define(version: 20150822211017) do

  create_table "orders", force: :cascade do |t|
    t.integer  "pin_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.text     "notification_params"
    t.string   "status"
    t.string   "transaction_id"
    t.datetime "purchased_at"
    t.string   "payer_email"
    t.string   "first_name"
    t.integer  "user_id"
  end

  add_index "orders", ["pin_id"], name: "index_orders_on_pin_id"
  add_index "orders", ["user_id"], name: "index_orders_on_user_id"

  create_table "payment_notifications", force: :cascade do |t|
    t.text     "params"
    t.string   "payer_email"
    t.string   "first_name"
    t.string   "transaction_id"
    t.string   "create"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "pins", force: :cascade do |t|
    t.string   "name"
    t.decimal  "price"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "user_id"
    t.text     "description"
    t.string   "download_link"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  add_index "pins", ["user_id"], name: "index_pins_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "email",                        default: "", null: false
    t.string   "encrypted_password",           default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.string   "profile_picture_file_name"
    t.string   "profile_picture_content_type"
    t.integer  "profile_picture_file_size"
    t.datetime "profile_picture_updated_at"
    t.string   "username"
    t.string   "bio"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
