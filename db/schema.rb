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

ActiveRecord::Schema.define(version: 20151126143212) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
    t.date     "call_date"
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

  create_table "locations", force: :cascade do |t|
    t.datetime "event_time"
    t.string   "lat"
    t.string   "long"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "username"
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

end
