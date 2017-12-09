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

ActiveRecord::Schema.define(version: 20171209024424) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "object_statuses", force: :cascade do |t|
    t.integer "object_id", null: false
    t.string "object_type", null: false
    t.string "timestamp", null: false
    t.jsonb "object_changes", null: false
    t.index ["object_type", "object_id", "timestamp", "object_changes"], name: "uniq_object_statuses_record_index", unique: true
  end

end
