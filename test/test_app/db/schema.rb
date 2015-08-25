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

ActiveRecord::Schema.define(version: 20150703230803) do

  create_table "auth_credentials", force: :cascade do |t|
    t.datetime "expires_at",           null: false
    t.string   "authenticatable_type", null: false
    t.integer  "authenticatable_id",   null: false
    t.string   "secret",               null: false
    t.string   "nonce",                null: false
    t.string   "scopes",               null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "auth_credentials", ["authenticatable_type", "authenticatable_id"], name: "idx_auth_cred_on_auth_type_auth_id", unique: true
  add_index "auth_credentials", ["expires_at"], name: "idx_auth_cred_on_expires_at"

  create_table "facebook_credentials", force: :cascade do |t|
    t.string   "authenticatable_type", null: false
    t.integer  "authenticatable_id",   null: false
    t.string   "uid",                  null: false
    t.string   "token",                null: false
    t.datetime "expires_at",           null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true

end
