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

ActiveRecord::Schema[7.1].define(version: 2023_11_19_100813) do
  create_table "new_models", force: :cascade do |t|
    t.integer "room_id", null: false
    t.string "title"
    t.string "level"
    t.json "tags"
    t.datetime "expired"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "problemId"
    t.index ["room_id"], name: "index_new_models_on_room_id"
  end

  create_table "room_problems", force: :cascade do |t|
    t.integer "room_id"
    t.json "ids"
    t.datetime "timeExpired"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rooms", force: :cascade do |t|
    t.string "name"
    t.json "ids"
    t.string "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "testms", force: :cascade do |t|
    t.string "name"
    t.json "ids"
    t.string "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "new_models", "rooms"
end
