# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_10_03_110014) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ingredients", force: :cascade do |t|
    t.bigint "recipe_id", null: false
    t.bigint "portion_id"
    t.decimal "amount", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "measure", default: 1, null: false
    t.integer "kcal", default: 0, null: false
    t.decimal "carbs", precision: 10, scale: 3, default: "0.0", null: false
    t.decimal "carbs_sugar_part", precision: 10, scale: 3, default: "0.0", null: false
    t.decimal "protein", precision: 10, scale: 3, default: "0.0", null: false
    t.decimal "fat", precision: 10, scale: 3, default: "0.0", null: false
    t.decimal "fat_saturated", precision: 10, scale: 3, default: "0.0", null: false
    t.decimal "fiber", precision: 10, scale: 3, default: "0.0", null: false
    t.index ["portion_id"], name: "index_ingredients_on_portion_id"
    t.index ["recipe_id"], name: "index_ingredients_on_recipe_id"
  end

  create_table "journal_days", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.date "date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date", "user_id"], name: "index_journal_days_on_date_and_user_id", unique: true
    t.index ["user_id"], name: "index_journal_days_on_user_id"
  end

  create_table "meals", force: :cascade do |t|
    t.bigint "journal_day_id"
    t.bigint "portion_id"
    t.bigint "recipe_id"
    t.decimal "amount"
    t.integer "measure"
    t.integer "measure_unit", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["journal_day_id"], name: "index_meals_on_journal_day_id"
    t.index ["portion_id"], name: "index_meals_on_portion_id"
    t.index ["recipe_id"], name: "index_meals_on_recipe_id"
  end

  create_table "nutritions", force: :cascade do |t|
    t.string "name", null: false
    t.integer "unit", default: 1, null: false
    t.integer "kcal", null: false
    t.decimal "carbs", precision: 10, scale: 3, null: false
    t.decimal "carbs_sugar_part", precision: 10, scale: 3, null: false
    t.decimal "protein", precision: 10, scale: 3, null: false
    t.decimal "fat", precision: 10, scale: 3, null: false
    t.decimal "fat_saturated", precision: 10, scale: 3, null: false
    t.decimal "fiber", precision: 10, scale: 3, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "vegan", default: false, null: false
    t.index ["name"], name: "index_nutritions_on_name", unique: true
  end

  create_table "portions", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "nutrition_id", null: false
    t.integer "amount", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "kcal", default: 0, null: false
    t.decimal "carbs", precision: 10, scale: 3, default: "0.0", null: false
    t.decimal "carbs_sugar_part", precision: 10, scale: 3, default: "0.0", null: false
    t.decimal "protein", precision: 10, scale: 3, default: "0.0", null: false
    t.decimal "fat", precision: 10, scale: 3, default: "0.0", null: false
    t.decimal "fat_saturated", precision: 10, scale: 3, default: "0.0", null: false
    t.decimal "fiber", precision: 10, scale: 3, default: "0.0", null: false
    t.index ["nutrition_id", "amount"], name: "index_portions_on_nutrition_id_and_amount", unique: true
    t.index ["nutrition_id", "name"], name: "index_portions_on_nutrition_id_and_name", unique: true
    t.index ["nutrition_id"], name: "index_portions_on_nutrition_id"
  end

  create_table "recipes", force: :cascade do |t|
    t.string "name", null: false
    t.integer "servings", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "vegan", default: false, null: false
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
  add_foreign_key "meals", "journal_days"
  add_foreign_key "meals", "portions"
  add_foreign_key "meals", "recipes"
  add_foreign_key "portions", "nutritions"
end
