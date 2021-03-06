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

ActiveRecord::Schema.define(version: 20170124001009) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "campaigns", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.boolean  "dm_only_exp_editing"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "characters", force: :cascade do |t|
    t.string   "name"
    t.string   "gender"
    t.integer  "level"
    t.integer  "exp"
    t.string   "character_class"
    t.string   "race"
    t.string   "background"
    t.integer  "user_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["user_id"], name: "index_characters_on_user_id", using: :btree
  end

  create_table "skills", force: :cascade do |t|
    t.string   "name"
    t.boolean  "proficient"
    t.integer  "bonus"
    t.integer  "character_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["character_id"], name: "index_skills_on_character_id", using: :btree
  end

  create_table "traits", force: :cascade do |t|
    t.string   "name"
    t.integer  "value"
    t.integer  "modifier"
    t.boolean  "saving_throw"
    t.integer  "character_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["character_id"], name: "index_traits_on_character_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "email"
    t.string   "password_digest"
    t.string   "about_me"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

end
