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

ActiveRecord::Schema.define(version: 20160121171400) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "app_names", force: :cascade do |t|
    t.string   "longname"
    t.string   "shortname"
    t.string   "color"
    t.integer  "priority"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "app_uniques", force: :cascade do |t|
    t.datetime "event_time"
    t.string   "app_name"
    t.string   "username"
    t.string   "event_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "apps", force: :cascade do |t|
    t.datetime "event_time"
    t.string   "app_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "username"
    t.string   "event_type"
    t.datetime "last_used"
    t.string   "total_use"
  end

  create_table "backups", force: :cascade do |t|
    t.datetime "started"
    t.datetime "ended"
    t.string   "username"
    t.string   "ref"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "browsers", force: :cascade do |t|
    t.string   "username"
    t.string   "title"
    t.string   "url"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.datetime "visit_date"
    t.integer  "visit_total"
  end

  create_table "calls", force: :cascade do |t|
    t.datetime "event_time"
    t.string   "call_number"
    t.string   "call_type"
    t.string   "call_duration"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "username"
  end

  create_table "contacts", force: :cascade do |t|
    t.datetime "event_time"
    t.string   "contact_name"
    t.string   "contact_number"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "username"
  end

  create_table "facebook_messages", force: :cascade do |t|
    t.datetime "fb_date"
    t.string   "fb_content"
    t.string   "fb_from"
    t.string   "username"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "message_type"
    t.integer  "stack_level"
  end

  create_table "locations", force: :cascade do |t|
    t.datetime "event_time"
    t.string   "lat"
    t.string   "long"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "username"
  end

  create_table "people", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone"
    t.string   "alt_phone"
    t.string   "google"
    t.string   "facebook"
    t.string   "twitter"
    t.boolean  "whitelist"
    t.string   "image"
    t.integer  "gender"
    t.text     "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "photos", force: :cascade do |t|
    t.string   "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "username"
    t.string   "width"
    t.string   "height"
    t.string   "model"
    t.datetime "photo_date"
    t.string   "photo_lat"
    t.string   "photo_long"
  end

  create_table "screens", force: :cascade do |t|
    t.datetime "event_time"
    t.string   "event_type"
    t.string   "username"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sims", force: :cascade do |t|
    t.datetime "event_time"
    t.string   "event_type"
    t.string   "username"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sms_messages", force: :cascade do |t|
    t.datetime "sms_date"
    t.text     "sms_content"
    t.string   "sms_sender"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "username"
    t.string   "white_list"
    t.string   "sms_folder"
  end

  create_table "timelines", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "whatsapp_messages", force: :cascade do |t|
    t.datetime "wa_date"
    t.string   "wa_content"
    t.string   "wa_from"
    t.string   "username"
    t.string   "message_type"
    t.integer  "stack_level"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

end
