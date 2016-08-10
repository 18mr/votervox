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

ActiveRecord::Schema.define(version: 20160810232736) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ahoy_events", force: :cascade do |t|
    t.integer  "visit_id"
    t.integer  "volunteer_id"
    t.string   "name"
    t.json     "properties"
    t.datetime "time"
  end

  add_index "ahoy_events", ["name", "time"], name: "index_ahoy_events_on_name_and_time", using: :btree
  add_index "ahoy_events", ["visit_id", "name"], name: "index_ahoy_events_on_visit_id_and_name", using: :btree
  add_index "ahoy_events", ["volunteer_id", "name"], name: "index_ahoy_events_on_volunteer_id_and_name", using: :btree

  create_table "documents", force: :cascade do |t|
    t.integer  "submitter_id"
    t.string   "name"
    t.string   "language"
    t.string   "translated_language"
    t.string   "resource_type"
    t.string   "location"
    t.string   "location_type"
    t.integer  "status",              default: 0
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "documents", ["submitter_id"], name: "index_documents_on_submitter_id", using: :btree

  create_table "interactions", force: :cascade do |t|
    t.integer  "match_id"
    t.integer  "duration",     default: 0
    t.integer  "contact_type"
    t.string   "message"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "interactions", ["match_id"], name: "index_interactions_on_match_id", using: :btree

  create_table "matches", force: :cascade do |t|
    t.integer  "voter_id"
    t.integer  "volunteer_id"
    t.integer  "status",       default: 0
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "matches", ["volunteer_id"], name: "index_matches_on_volunteer_id", using: :btree
  add_index "matches", ["voter_id"], name: "index_matches_on_voter_id", using: :btree

  create_table "organizations", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "visits", force: :cascade do |t|
    t.string   "visit_token"
    t.string   "visitor_token"
    t.string   "ip"
    t.text     "user_agent"
    t.text     "referrer"
    t.text     "landing_page"
    t.integer  "volunteer_id"
    t.string   "referring_domain"
    t.string   "search_keyword"
    t.string   "browser"
    t.string   "os"
    t.string   "device_type"
    t.integer  "screen_height"
    t.integer  "screen_width"
    t.string   "country"
    t.string   "region"
    t.string   "city"
    t.string   "postal_code"
    t.decimal  "latitude"
    t.decimal  "longitude"
    t.string   "utm_source"
    t.string   "utm_medium"
    t.string   "utm_term"
    t.string   "utm_content"
    t.string   "utm_campaign"
    t.datetime "started_at"
  end

  add_index "visits", ["visit_token"], name: "index_visits_on_visit_token", unique: true, using: :btree
  add_index "visits", ["volunteer_id"], name: "index_visits_on_volunteer_id", using: :btree

  create_table "volunteers", force: :cascade do |t|
    t.string   "email",                      default: "",    null: false
    t.string   "encrypted_password",         default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",              default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "firstname"
    t.string   "lastname"
    t.string   "phone"
    t.string   "address"
    t.integer  "organization_id"
    t.string   "languages",                  default: [],                 array: true
    t.boolean  "admin",                      default: false
    t.integer  "status",                     default: 0
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.string   "city"
    t.string   "state"
    t.string   "profile_image_file_name"
    t.string   "profile_image_content_type"
    t.integer  "profile_image_file_size"
    t.datetime "profile_image_updated_at"
  end

  add_index "volunteers", ["email"], name: "index_volunteers_on_email", unique: true, using: :btree
  add_index "volunteers", ["reset_password_token"], name: "index_volunteers_on_reset_password_token", unique: true, using: :btree

  create_table "voters", force: :cascade do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.string   "communication_mode"
    t.string   "contact"
    t.string   "address"
    t.integer  "english_comfort"
    t.boolean  "first_time_voter"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "languages",          default: [],                array: true
    t.string   "city"
    t.string   "state"
    t.boolean  "active",             default: true
  end

  add_foreign_key "documents", "volunteers", column: "submitter_id"
  add_foreign_key "interactions", "matches"
  add_foreign_key "matches", "volunteers"
  add_foreign_key "matches", "voters"
end
