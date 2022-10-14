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

ActiveRecord::Schema[7.0].define(version: 2022_09_23_122617) do
  create_table "admins", force: :cascade do |t|
    t.string "name"
    t.string "password"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "unique_emails", unique: true
  end

  create_table "forecasts", force: :cascade do |t|
    t.string "result"
    t.integer "home_goals"
    t.integer "away_goals"
    t.integer "points"
    t.integer "player_id"
    t.integer "tournament_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "match_id"
    t.index ["match_id"], name: "index_forecasts_on_match_id"
    t.index ["player_id"], name: "index_forecasts_on_player_id"
    t.index ["tournament_id"], name: "index_forecasts_on_tournament_id"
  end

  create_table "match_days", force: :cascade do |t|
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "tournament_id"
    t.index ["tournament_id"], name: "index_match_days_on_tournament_id"
  end

  create_table "matches", force: :cascade do |t|
    t.string "result"
    t.integer "home_goals"
    t.integer "away_goals"
    t.datetime "datetime"
    t.string "match_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "home_id"
    t.integer "away_id"
    t.integer "match_day_id"
    t.index ["away_id"], name: "index_matches_on_away_id"
    t.index ["home_id"], name: "index_matches_on_home_id"
    t.index ["match_day_id"], name: "index_matches_on_match_day_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_admin"
  end

  create_table "points", force: :cascade do |t|
    t.integer "total_points"
    t.integer "tournament_id"
    t.integer "player_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_points_on_player_id"
    t.index ["tournament_id"], name: "index_points_on_tournament_id"
  end

  create_table "pw_recoveries", force: :cascade do |t|
    t.string "email"
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "player_id"
    t.index ["player_id"], name: "index_pw_recoveries_on_player_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teams_tournaments", force: :cascade do |t|
    t.integer "team_id"
    t.integer "tournament_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_teams_tournaments_on_team_id"
    t.index ["tournament_id"], name: "index_teams_tournaments_on_tournament_id"
  end

  create_table "tournaments", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "matches", "teams", column: "away_id"
  add_foreign_key "matches", "teams", column: "home_id"
  add_foreign_key "pw_recoveries", "players"
end
