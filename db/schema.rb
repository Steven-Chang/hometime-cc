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

ActiveRecord::Schema[7.0].define(version: 2023_08_08_080026) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "guests", force: :cascade do |t|
    t.string "email", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_guests_on_email", unique: true
  end

  create_table "phone_numbers", force: :cascade do |t|
    t.string "phone_number", null: false
    t.string "owner_type", null: false
    t.bigint "owner_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_type", "owner_id", "phone_number"], name: "phone_numbers_by_owner_phone_number", unique: true
  end

  create_table "reservations", force: :cascade do |t|
    t.string "code", null: false
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.integer "nights", null: false
    t.integer "guests", null: false
    t.integer "adults", null: false
    t.integer "children", null: false
    t.integer "infants", null: false
    t.integer "status", null: false
    t.integer "currency", null: false
    t.string "payout_price", null: false
    t.string "security_price", null: false
    t.string "total_price", null: false
    t.bigint "guest_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_reservations_on_code", unique: true
    t.index ["guest_id"], name: "index_reservations_on_guest_id"
  end

  add_foreign_key "reservations", "guests", name: "reservations_guest_id_fk"
end
