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

ActiveRecord::Schema[8.0].define(version: 2026_05_29_120000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "band_invitations", force: :cascade do |t|
    t.bigint "band_id", null: false
    t.string "token_digest"
    t.datetime "expires_at"
    t.datetime "used_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["band_id"], name: "index_band_invitations_on_band_id"
    t.index ["token_digest"], name: "index_band_invitations_on_token_digest", unique: true
  end

  create_table "bands", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bands_players", id: false, force: :cascade do |t|
    t.bigint "band_id", null: false
    t.bigint "player_id", null: false
    t.index ["band_id", "player_id"], name: "index_bands_players_on_band_id_and_player_id", unique: true
    t.index ["player_id", "band_id"], name: "index_bands_players_on_player_id_and_band_id"
  end

  create_table "instruments", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "instruments_players", id: false, force: :cascade do |t|
    t.bigint "instrument_id", null: false
    t.bigint "player_id", null: false
  end

  create_table "list_songs", force: :cascade do |t|
    t.bigint "list_id"
    t.bigint "song_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["list_id"], name: "index_list_songs_on_list_id"
    t.index ["song_id"], name: "index_list_songs_on_song_id"
  end

  create_table "lists", force: :cascade do |t|
    t.string "name"
    t.string "notes"
    t.bigint "band_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["band_id"], name: "index_lists_on_band_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.bigint "band_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", null: false
    t.string "encrypted_password", limit: 128, null: false
    t.string "confirmation_token", limit: 128
    t.string "remember_token", limit: 128, null: false
    t.boolean "admin", default: false, null: false
    t.datetime "invitation_accepted_at"
    t.index ["band_id"], name: "index_players_on_band_id"
    t.index ["confirmation_token"], name: "index_players_on_confirmation_token", unique: true
    t.index ["email"], name: "index_players_on_email"
    t.index ["remember_token"], name: "index_players_on_remember_token", unique: true
  end

  create_table "preparations", force: :cascade do |t|
    t.string "instruction"
    t.bigint "song_id"
    t.bigint "instrument_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["instrument_id"], name: "index_preparations_on_instrument_id"
    t.index ["song_id"], name: "index_preparations_on_song_id"
  end

  create_table "sheet_instruments", force: :cascade do |t|
    t.bigint "sheet_id", null: false
    t.bigint "instrument_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["instrument_id"], name: "index_sheet_instruments_on_instrument_id"
    t.index ["sheet_id", "instrument_id"], name: "index_sheet_instruments_on_sheet_id_and_instrument_id", unique: true
    t.index ["sheet_id"], name: "index_sheet_instruments_on_sheet_id"
  end

  create_table "sheets", force: :cascade do |t|
    t.integer "sort_order", null: false
    t.bigint "song_id", null: false
    t.bigint "instrument_id"
    t.string "img"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["instrument_id"], name: "index_sheets_on_instrument_id"
    t.index ["song_id"], name: "index_sheets_on_song_id"
  end

  create_table "songs", force: :cascade do |t|
    t.string "title"
    t.string "version"
    t.string "performer"
    t.integer "duration"
    t.integer "tempo"
    t.string "intro"
    t.bigint "band_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "finish"
    t.index ["band_id"], name: "index_songs_on_band_id"
  end

  add_foreign_key "band_invitations", "bands"
  add_foreign_key "sheet_instruments", "instruments"
  add_foreign_key "sheet_instruments", "sheets"
end
