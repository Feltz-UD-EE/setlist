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

ActiveRecord::Schema[8.0].define(version: 2025_03_03_144256) do
  create_table "bands", charset: "utf8mb3", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "instruments", charset: "utf8mb3", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "instruments_players", id: false, charset: "utf8mb3", force: :cascade do |t|
    t.bigint "instrument_id", null: false
    t.bigint "player_id", null: false
  end

  create_table "list_songs", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "list_id"
    t.bigint "song_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["list_id"], name: "index_list_songs_on_list_id"
    t.index ["song_id"], name: "index_list_songs_on_song_id"
  end

  create_table "lists", charset: "utf8mb3", force: :cascade do |t|
    t.string "name"
    t.string "notes"
    t.bigint "band_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["band_id"], name: "index_lists_on_band_id"
  end

  create_table "players", charset: "utf8mb3", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.bigint "band_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", null: false
    t.string "encrypted_password", limit: 128, null: false
    t.string "confirmation_token", limit: 128
    t.string "remember_token", limit: 128, null: false
    t.index ["band_id"], name: "index_players_on_band_id"
    t.index ["confirmation_token"], name: "index_players_on_confirmation_token", unique: true
    t.index ["email"], name: "index_players_on_email"
    t.index ["remember_token"], name: "index_players_on_remember_token", unique: true
  end

  create_table "preparations", charset: "utf8mb3", force: :cascade do |t|
    t.string "instruction"
    t.bigint "song_id"
    t.bigint "instrument_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["instrument_id"], name: "index_preparations_on_instrument_id"
    t.index ["song_id"], name: "index_preparations_on_song_id"
  end

  create_table "songs", charset: "utf8mb3", force: :cascade do |t|
    t.string "title"
    t.string "version"
    t.string "performer"
    t.integer "duration"
    t.integer "tempo"
    t.string "intro"
    t.bigint "band_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["band_id"], name: "index_songs_on_band_id"
  end
end
