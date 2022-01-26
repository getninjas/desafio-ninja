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

ActiveRecord::Schema.define(version: 2022_01_24_230505) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "agendamentos", force: :cascade do |t|
    t.date "data"
    t.time "horario_inicio"
    t.time "horario_final"
    t.bigint "agenda_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["agenda_id"], name: "index_agendamentos_on_agenda_id"
  end

  create_table "agendas", force: :cascade do |t|
    t.bigint "sala_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["sala_id"], name: "index_agendas_on_sala_id"
  end

  create_table "salas", force: :cascade do |t|
    t.string "nome"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "agendamentos", "agendas"
  add_foreign_key "agendas", "salas"
end
