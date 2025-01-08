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

ActiveRecord::Schema[8.0].define(version: 2025_01_08_163036) do
  create_table "occupations", force: :cascade do |t|
    t.string "major"
    t.string "major_label"
    t.string "sub_major"
    t.string "sub_major_label"
    t.string "minor"
    t.string "minor_label"
    t.string "unit"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "people", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "country_of_birth"
    t.string "country_of_residence"
    t.string "country_of_profession"
    t.string "profession"
    t.boolean "pep"
    t.boolean "sanctioned"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sanctions", force: :cascade do |t|
    t.string "nature"
    t.string "title"
    t.string "last_name"
    t.string "first_name"
    t.string "sex"
    t.string "date_of_birth"
    t.string "place_of_birth"
    t.string "nationality"
    t.text "address"
    t.text "alias"
    t.string "authority"
    t.text "motive"
    t.string "legal_basis"
    t.text "additional_info"
    t.string "expiration_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
end
