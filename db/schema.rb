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

ActiveRecord::Schema[8.0].define(version: 2025_03_17_163348) do
  create_table "adverse_media_checks", force: :cascade do |t|
    t.string "status", default: "in progress"
    t.boolean "adverse_media_found"
    t.json "result"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "adverse_media_checkable_id"
    t.string "adverse_media_checkable_type"
    t.index ["adverse_media_checkable_id", "adverse_media_checkable_type"], name: "idx_on_adverse_media_checkable_id_adverse_media_che_72cfe96daf"
  end

  create_table "clients", force: :cascade do |t|
    t.string "clientable_type"
    t.integer "clientable_id"
    t.datetime "started_at"
    t.datetime "ended_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "notes"
    t.index ["clientable_id", "clientable_type"], name: "index_clients_on_clientable_id_and_clientable_type"
    t.index ["clientable_type", "clientable_id"], name: "index_clients_on_clientable"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "sanctioned"
    t.string "country"
  end

  create_table "company_relationships", force: :cascade do |t|
    t.integer "company_id", null: false
    t.integer "person_id", null: false
    t.integer "relationship_type", null: false
    t.decimal "ownership_percentage", precision: 5, scale: 2
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id", "person_id", "relationship_type"], name: "idx_company_relationships_unique", unique: true
    t.index ["company_id"], name: "index_company_relationships_on_company_id"
    t.index ["person_id"], name: "index_company_relationships_on_person_id"
  end

  create_table "identification_documents", force: :cascade do |t|
    t.integer "person_id", null: false
    t.string "document_type", null: false
    t.string "number", null: false
    t.date "expiration_date", null: false
    t.boolean "is_copy", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_identification_documents_on_person_id"
  end

  create_table "matches", force: :cascade do |t|
    t.integer "screening_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "score", default: 0
    t.json "external_data"
    t.index ["external_data"], name: "index_matches_on_external_data"
    t.index ["screening_id"], name: "index_matches_on_screening_id"
  end

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
    t.string "nationality"
    t.date "date_of_birth"
  end

  create_table "risk_factor_definitions", force: :cascade do |t|
    t.string "category", null: false
    t.text "description", null: false
    t.integer "score", null: false
    t.string "risk_factor_type", null: false
    t.string "identifier", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["risk_factor_type", "category", "identifier"], name: "idx_risk_factor_definitions_unique", unique: true
  end

  create_table "risk_factors", force: :cascade do |t|
    t.integer "category"
    t.string "identifier"
    t.datetime "identified_at"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "client_id"
    t.index ["client_id", "category", "identifier"], name: "index_risk_factors_on_client_id_and_category_and_identifier", unique: true
    t.index ["client_id"], name: "index_risk_factors_on_client_id"
  end

  create_table "risk_scoresheets", force: :cascade do |t|
    t.integer "country_risk_score"
    t.integer "client_risk_score"
    t.integer "products_and_services_risk_score"
    t.integer "distribution_channel_risk_score"
    t.integer "transaction_risk_score"
    t.datetime "approved_at"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "client_id"
    t.index ["client_id"], name: "index_risk_scoresheets_on_client_id"
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
    t.integer "measure_id"
    t.index ["measure_id"], name: "index_sanctions_on_measure_id"
  end

  create_table "screenings", force: :cascade do |t|
    t.integer "screenable_id"
    t.string "screenable_type"
    t.string "query"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["screenable_id", "screenable_type"], name: "index_screenings_on_screenable_id_and_screenable_type"
  end

  add_foreign_key "company_relationships", "companies"
  add_foreign_key "company_relationships", "people"
  add_foreign_key "identification_documents", "people"
  add_foreign_key "matches", "screenings"
  add_foreign_key "risk_factors", "clients"
  add_foreign_key "risk_scoresheets", "clients"
end
