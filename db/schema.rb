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

ActiveRecord::Schema.define(version: 20140618140519) do

  create_table "friends", force: true do |t|
    t.integer  "user_id"
    t.integer  "target_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "friends", ["user_id", "target_user_id"], name: "index_friends_on_user_id_and_target_user_id", unique: true
  add_index "friends", ["user_id"], name: "index_friends_on_user_id"

  create_table "participants", force: true do |t|
    t.integer  "wall_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "owner",      default: false
  end

  add_index "participants", ["user_id"], name: "index_participants_on_user_id"
  add_index "participants", ["wall_id", "user_id"], name: "index_participants_on_wall_id_and_user_id", unique: true
  add_index "participants", ["wall_id"], name: "index_participants_on_wall_id"

  create_table "posts", force: true do |t|
    t.integer  "participant_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "posts", ["participant_id", "created_at"], name: "index_posts_on_participant_id_and_created_at"

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_token"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["name"], name: "index_users_on_name", unique: true
  add_index "users", ["remember_token"], name: "index_users_on_remember_token"

  create_table "walls", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
