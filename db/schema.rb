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

ActiveRecord::Schema.define(version: 2022_02_16_032740) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "employee_schedulers", id: false, force: :cascade do |t|
    t.bigint "employee_id"
    t.bigint "scheduler_id"
    t.index ["employee_id"], name: "index_employee_schedulers_on_employee_id"
    t.index ["scheduler_id"], name: "index_employee_schedulers_on_scheduler_id"
  end

  create_table "employees", force: :cascade do |t|
    t.string "name"
    t.string "department"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "rooms", force: :cascade do |t|
    t.string "name"
    t.integer "open_at"
    t.integer "close_at"
    t.integer "people_limit_by_meeting"
    t.integer "time_limit_by_meeting"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "schedulers", force: :cascade do |t|
    t.datetime "start_meeting_time"
    t.datetime "end_meeting_time"
    t.string "meeting_description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "room_id", null: false
    t.index ["room_id"], name: "index_schedulers_on_room_id"
  end

  add_foreign_key "schedulers", "rooms"
end
