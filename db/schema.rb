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

ActiveRecord::Schema.define(version: 20190402124513) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "daily_reports", force: :cascade do |t|
    t.string "name_und_vorname"
    t.date "date"
    t.float "summe_lunchchecks"
    t.float "kreditkarte_total"
    t.float "mastercard"
    t.float "visa"
    t.float "maestro"
    t.float "andere"
    t.float "summe_treuekarte"
    t.float "summe_rabatte"
    t.float "summe_rechnung"
    t.float "summe_gutschein"
    t.integer "gutschein_nummer"
    t.float "summe_einkauf"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.boolean "status"
    t.float "bar"
    t.float "dinner_umsatz"
    t.integer "dinner_anzahl_personen"
    t.float "lunch_umsatz"
    t.integer "lunch_anzahl_personen"
    t.string "business"
    t.float "total_umsatz"
    t.bigint "spreadsheet_id"
    t.index ["spreadsheet_id"], name: "index_daily_reports_on_spreadsheet_id"
    t.index ["user_id"], name: "index_daily_reports_on_user_id"
  end

  create_table "spreadsheets", force: :cascade do |t|
    t.string "remote_id"
    t.integer "year"
    t.string "business"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.string "email"
    t.string "full_name"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "daily_reports", "spreadsheets"
  add_foreign_key "daily_reports", "users"
end
