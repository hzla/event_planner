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

ActiveRecord::Schema.define(version: 20150115025423) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authorizations", force: true do |t|
    t.string   "provider",   default: "facebook"
    t.string   "uu_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "authorizations", ["user_id", "uu_id"], name: "index_authorizations_on_user_id_and_uu_id", using: :btree

  create_table "choices", force: true do |t|
    t.string   "value"
    t.text     "add_info"
    t.integer  "poll_id"
    t.string   "image_url"
    t.boolean  "yes"
    t.integer  "service_id"
    t.datetime "time"
    t.integer  "event_id"
    t.string   "choice_type"
    t.string   "question"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "position"
    t.string   "integer"
    t.integer  "sub_position"
  end

  add_index "choices", ["event_id", "value"], name: "index_choices_on_event_id_and_value", using: :btree
  add_index "choices", ["poll_id"], name: "index_choices_on_poll_id", using: :btree

  create_table "events", force: true do |t|
    t.integer  "user_id"
    t.integer  "service_id"
    t.string   "name"
    t.text     "comment"
    t.string   "status",            default: "dormant"
    t.integer  "confirmation_id"
    t.string   "current_choice"
    t.integer  "threshold"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "start_date"
    t.datetime "end_time"
    t.datetime "expiration"
    t.string   "recurring"
    t.datetime "start_time"
    t.string   "processing_choice"
    t.string   "routing_url"
    t.boolean  "locked"
  end

  add_index "events", ["user_id"], name: "index_events_on_user_id", using: :btree

  create_table "logs", force: true do |t|
    t.integer  "event_id"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "outings", force: true do |t|
    t.integer "user_id"
    t.integer "event_id"
  end

  add_index "outings", ["user_id", "event_id"], name: "index_outings_on_user_id_and_event_id", using: :btree

  create_table "polls", force: true do |t|
    t.boolean "answered",            default: false
    t.string  "url"
    t.integer "event_id"
    t.string  "email"
    t.string  "phone_number"
    t.integer "user_id"
    t.boolean "confirmed_attending"
  end

  add_index "polls", ["event_id"], name: "index_polls_on_event_id", using: :btree
  add_index "polls", ["user_id"], name: "index_polls_on_user_id", using: :btree

  create_table "restaurants", force: true do |t|
    t.string   "name"
    t.string   "address"
    t.integer  "review_count"
    t.integer  "pricing"
    t.float    "rating"
    t.string   "city"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "opentable_id"
    t.string   "cuisine"
    t.string   "lat"
    t.string   "long"
    t.string   "pricing_info"
    t.integer  "popularity"
  end

  create_table "services", force: true do |t|
    t.string  "name"
    t.string  "image"
    t.string  "url"
    t.string  "img_ext",   default: "svg"
    t.boolean "available", default: true
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "school"
    t.string   "profile_pic_url"
    t.string   "fb_token"
    t.string   "activation"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "location"
    t.string   "phone_number"
    t.integer  "uu_id"
    t.boolean  "mail_on_vote",        default: true
    t.boolean  "mail_on_res_success", default: true
    t.boolean  "mail_on_res_failure", default: true
    t.boolean  "mail_on_res_24_hour", default: true
    t.string   "role"
  end

end
