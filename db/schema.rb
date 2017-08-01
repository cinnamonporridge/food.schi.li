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

ActiveRecord::Schema.define(version: 20170730115501) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ingredients", force: :cascade do |t|
    t.bigint "recipe_id", null: false
    t.bigint "portion_id"
    t.decimal "amount", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "measure", default: 1, null: false
    t.index ["portion_id"], name: "index_ingredients_on_portion_id"
    t.index ["recipe_id"], name: "index_ingredients_on_recipe_id"
  end

  create_table "journal_days", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.date "date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_journal_days_on_user_id"
  end

  create_table "nutritions", force: :cascade do |t|
    t.string "name", null: false
    t.integer "unit", default: 1, null: false
    t.integer "kcal", default: 0, null: false
    t.decimal "carbs", precision: 10, scale: 3, default: "0.0", null: false
    t.decimal "carbs_sugar_part", precision: 10, scale: 3, default: "0.0", null: false
    t.decimal "protein", precision: 10, scale: 3, default: "0.0", null: false
    t.decimal "fat", precision: 10, scale: 3, default: "0.0", null: false
    t.decimal "fat_saturated", precision: 10, scale: 3, default: "0.0", null: false
    t.decimal "fiber", precision: 10, scale: 3, default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "portions", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "nutrition_id", null: false
    t.integer "amount", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["nutrition_id"], name: "index_portions_on_nutrition_id"
  end

  create_table "recipes", force: :cascade do |t|
    t.string "name", null: false
    t.integer "servings", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "reset_password_link_sent_at"
    t.string "reset_password_challenge"
    t.datetime "magic_link_sent_at"
    t.string "magic_link_challenge"
    t.boolean "is_admin", default: false, null: false
  end

  add_foreign_key "ingredients", "recipes"
  add_foreign_key "journal_days", "users"
  add_foreign_key "portions", "nutritions"
end
