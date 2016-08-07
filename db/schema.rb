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

ActiveRecord::Schema.define(version: 20160807003450) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  create_table "volunteers", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "firstname"
    t.string   "lastname"
    t.string   "phone"
    t.string   "address"
    t.integer  "organization_id"
    t.string   "languages",              default: [],                 array: true
    t.boolean  "admin",                  default: false
    t.integer  "status",                 default: 0
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "city"
    t.string   "state"
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
