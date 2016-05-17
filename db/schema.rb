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

ActiveRecord::Schema.define(version: 20160419031953) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "games", force: :cascade do |t|
    t.string   "name",                             null: false
    t.integer  "white_player_id"
    t.integer  "black_player_id"
    t.boolean  "white_can_castle", default: false, null: false
    t.boolean  "black_can_castle", default: false, null: false
    t.boolean  "white_to_move",    default: true,  null: false
    t.string   "state",                            null: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "games", ["black_player_id", "state"], name: "index_games_on_black_player_id_and_state", using: :btree
  add_index "games", ["white_player_id", "state"], name: "index_games_on_white_player_id_and_state", using: :btree

  create_table "pieces", force: :cascade do |t|
    t.string   "type",                       null: false
    t.string   "color",                      null: false
    t.integer  "rank",                       null: false
    t.integer  "file",                       null: false
    t.integer  "game_id",                    null: false
    t.boolean  "en_passant", default: false, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "pieces", ["game_id", "color"], name: "index_pieces_on_game_id_and_color", using: :btree
  add_index "pieces", ["game_id", "type"], name: "index_pieces_on_game_id_and_type", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "provider"
    t.string   "uid"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "games", "users", column: "black_player_id"
  add_foreign_key "games", "users", column: "white_player_id"
  add_foreign_key "pieces", "games", on_delete: :cascade
end
