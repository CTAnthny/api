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

ActiveRecord::Schema.define(version: 20170504192146) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "challenges", force: :cascade do |t|
    t.integer  "github_issue_id"
    t.string   "body",            default: ""
    t.string   "state",           default: ""
    t.string   "title"
    t.string   "url",             default: ""
    t.string   "repo",            default: ""
    t.json     "labels",          default: []
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "cred_transactions", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.float    "delta"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_cred_transactions_on_event_id", using: :btree
    t.index ["user_id"], name: "index_cred_transactions_on_user_id", using: :btree
  end

  create_table "credits", force: :cascade do |t|
    t.string   "name"
    t.float    "points_per_unit", default: 0.0
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "title",           default: ""
    t.string   "description",     default: ""
  end

  create_table "events", force: :cascade do |t|
    t.string   "category"
    t.integer  "user_id"
    t.integer  "quantity",   default: 1
    t.json     "info",       default: {}
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "credit_id"
    t.index ["credit_id"], name: "index_events_on_credit_id", using: :btree
    t.index ["user_id"], name: "index_events_on_user_id", using: :btree
  end

  create_table "tokens", force: :cascade do |t|
    t.string   "token"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "picture",           default: ""
    t.string   "codewars_handle",   default: ""
    t.string   "github_handle",     default: ""
    t.string   "linkedin_url",      default: ""
    t.string   "resume_site_url",   default: ""
    t.string   "stackoverflow_url", default: ""
    t.string   "twitter_handle",    default: ""
    t.integer  "codewars_honor",    default: 0
  end

  add_foreign_key "cred_transactions", "events"
  add_foreign_key "cred_transactions", "users"
  add_foreign_key "events", "users"
end
