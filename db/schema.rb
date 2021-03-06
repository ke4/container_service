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

ActiveRecord::Schema.define(version: 20160505153148) do

  create_table "labware_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "layout_id"
  end

  add_index "labware_types", ["layout_id"], name: "index_labware_types_on_layout_id"

  create_table "labwares", force: :cascade do |t|
    t.string   "barcode"
    t.string   "external_id"
    t.string   "uuid"
    t.integer  "labware_type_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "labwares", ["barcode"], name: "index_labwares_on_barcode"
  add_index "labwares", ["external_id"], name: "index_labwares_on_external_id"
  add_index "labwares", ["labware_type_id"], name: "index_labwares_on_labware_type_id"
  add_index "labwares", ["uuid"], name: "index_labwares_on_uuid"

  create_table "layouts", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "locations", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "layout_id"
  end

  add_index "locations", ["layout_id"], name: "index_locations_on_layout_id"

  create_table "metadata", force: :cascade do |t|
    t.string   "key"
    t.string   "value"
    t.integer  "labware_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "metadata", ["key", "labware_id"], name: "index_metadata_on_key_and_labware_id", unique: true
  add_index "metadata", ["labware_id"], name: "index_metadata_on_labware_id"

  create_table "receptacles", force: :cascade do |t|
    t.integer  "labware_id"
    t.integer  "location_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "material_uuid"
  end

  add_index "receptacles", ["labware_id"], name: "index_receptacles_on_labware_id"
  add_index "receptacles", ["location_id"], name: "index_receptacles_on_location_id"

end
