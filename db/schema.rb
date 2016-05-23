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

ActiveRecord::Schema.define(version: 20160523170015) do

  create_table "cliqs", force: :cascade do |t|
    t.string   "customer_id"
    t.string   "stripe_secret_key"
    t.string   "stripe_publishable_key"
    t.string   "name"
    t.text     "description"
    t.text     "thank_you_message"
    t.decimal  "price",                  precision: 8, scale: 2
    t.integer  "owner_id"
    t.datetime "created_at",                                                 null: false
    t.datetime "updated_at",                                                 null: false
    t.string   "email"
    t.integer  "subscription_count",                             default: 0
  end

  create_table "comments", force: :cascade do |t|
    t.datetime "created_at",                       null: false
    t.text     "content"
    t.boolean  "removed",          default: false
    t.integer  "owner_id"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.datetime "updated_at",                       null: false
  end

  add_index "comments", ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id"

  create_table "conversations", force: :cascade do |t|
    t.string   "name"
    t.datetime "updated_at", null: false
    t.datetime "created_at", null: false
  end

  create_table "conversations_users", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "conversation_id"
  end

  create_table "downloads", force: :cascade do |t|
    t.integer  "track_id"
    t.integer  "downloader_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "favourites", force: :cascade do |t|
    t.integer  "favouritable_id"
    t.string   "favouritable_type"
    t.integer  "favouriter_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "favourites", ["favouritable_type", "favouritable_id"], name: "index_favourites_on_favouritable_type_and_favouritable_id"

  create_table "follows", force: :cascade do |t|
    t.integer  "follower_id"
    t.integer  "following_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "mentions", force: :cascade do |t|
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "mentionable_id"
    t.string   "mentionable_type"
    t.integer  "mentioned_id"
  end

  add_index "mentions", ["mentionable_type", "mentionable_id"], name: "index_mentions_on_mentionable_type_and_mentionable_id"

  create_table "messages", force: :cascade do |t|
    t.text     "content"
    t.integer  "creator_id"
    t.integer  "conversation_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.boolean  "read",            default: false
    t.integer  "user_id"
    t.integer  "notifiable_id"
    t.string   "notifiable_type"
    t.integer  "initiator_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "notifications", ["notifiable_type", "notifiable_id"], name: "index_notifications_on_notifiable_type_and_notifiable_id"

  create_table "posts", force: :cascade do |t|
    t.text     "content"
    t.boolean  "clique_only",      default: false
    t.boolean  "removed",          default: false
    t.integer  "owner_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "favourites_count", default: 0
  end

  create_table "reposts", force: :cascade do |t|
    t.integer  "reposter_id"
    t.integer  "post_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "retracks", force: :cascade do |t|
    t.integer  "reposter_id"
    t.integer  "track_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer  "clique_id"
    t.integer  "subscriber_id"
    t.string   "stripe_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "tracks", force: :cascade do |t|
    t.string   "song_file_name"
    t.string   "song_content_type"
    t.integer  "song_file_size"
    t.datetime "song_updated_at"
    t.string   "pic_file_name"
    t.string   "pic_content_type"
    t.integer  "pic_file_size"
    t.datetime "pic_updated_at"
    t.string   "name"
    t.string   "desc"
    t.boolean  "downloadable"
    t.integer  "owner_id"
    t.boolean  "removed",           default: false
    t.boolean  "clique_only",       default: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "favourites_count",  default: 0
    t.integer  "downloads_count",   default: 0
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "gender"
    t.string   "birthday"
    t.string   "phone"
    t.string   "username"
    t.integer  "type"
    t.string   "customer_id"
    t.string   "profile_picture_file_name"
    t.string   "profile_picture_content_type"
    t.integer  "profile_picture_file_size"
    t.datetime "profile_picture_updated_at"
    t.string   "cover_picture_file_name"
    t.string   "cover_picture_content_type"
    t.integer  "cover_picture_file_size"
    t.datetime "cover_picture_updated_at"
    t.string   "cover_picture_url"
    t.string   "profile_picture_url"
    t.text     "bio"
    t.string   "address"
    t.string   "city"
    t.string   "country"
    t.string   "email",                        default: "", null: false
    t.string   "soundcloud_name"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.string   "provider"
    t.string   "uid"
    t.string   "encrypted_password",           default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",              default: 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "preapprovalKey"
    t.string   "state"
    t.string   "postal_code"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true

end
