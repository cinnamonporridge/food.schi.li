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

ActiveRecord::Schema[8.1].define(version: 2026_04_06_122649) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "day_partitions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "position", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id", "name"], name: "index_day_partitions_on_user_id_and_name", unique: true
    t.index ["user_id", "position"], name: "index_day_partitions_on_user_id_and_position", unique: true
    t.index ["user_id"], name: "index_day_partitions_on_user_id"
  end

  create_table "foods", force: :cascade do |t|
    t.decimal "carbs", precision: 10, scale: 3, null: false
    t.decimal "carbs_sugar_part", precision: 10, scale: 3, null: false
    t.datetime "created_at", null: false
    t.datetime "data_source_updated_at"
    t.string "data_source_url"
    t.decimal "fat", precision: 10, scale: 3, null: false
    t.decimal "fat_saturated", precision: 10, scale: 3, null: false
    t.decimal "fiber", precision: 10, scale: 3, null: false
    t.integer "kcal", null: false
    t.string "name", null: false
    t.decimal "protein", precision: 10, scale: 3, null: false
    t.string "unit", default: "gram", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.boolean "vegan", default: false, null: false
    t.index ["name"], name: "index_foods_on_name", unique: true
    t.index ["user_id"], name: "index_foods_on_user_id"
  end

  create_table "journal_days", force: :cascade do |t|
    t.decimal "carbs", precision: 10, scale: 3, default: "0.0", null: false
    t.decimal "carbs_sugar_part", precision: 10, scale: 3, default: "0.0", null: false
    t.datetime "created_at", null: false
    t.date "date", null: false
    t.decimal "fat", precision: 10, scale: 3, default: "0.0", null: false
    t.decimal "fat_saturated", precision: 10, scale: 3, default: "0.0", null: false
    t.decimal "fiber", precision: 10, scale: 3, default: "0.0", null: false
    t.integer "kcal", default: 0, null: false
    t.decimal "protein", precision: 10, scale: 3, default: "0.0", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.boolean "vegan", default: false, null: false
    t.index ["date", "user_id"], name: "index_journal_days_on_date_and_user_id", unique: true
    t.index ["user_id"], name: "index_journal_days_on_user_id"
  end

  create_table "meal_ingredients", force: :cascade do |t|
    t.decimal "amount", null: false
    t.decimal "carbs", precision: 10, scale: 3, default: "0.0", null: false
    t.decimal "carbs_sugar_part", precision: 10, scale: 3, default: "0.0", null: false
    t.datetime "created_at", null: false
    t.decimal "fat", precision: 10, scale: 3, default: "0.0", null: false
    t.decimal "fat_saturated", precision: 10, scale: 3, default: "0.0", null: false
    t.decimal "fiber", precision: 10, scale: 3, default: "0.0", null: false
    t.integer "kcal", default: 0, null: false
    t.bigint "meal_id", null: false
    t.string "measure", default: "unit", null: false
    t.bigint "portion_id", null: false
    t.decimal "protein", precision: 10, scale: 3, default: "0.0", null: false
    t.datetime "updated_at", null: false
    t.index ["meal_id"], name: "index_meal_ingredients_on_meal_id"
    t.index ["portion_id"], name: "index_meal_ingredients_on_portion_id"
  end

  create_table "meals", force: :cascade do |t|
    t.decimal "carbs", precision: 10, scale: 3, default: "0.0", null: false
    t.decimal "carbs_sugar_part", precision: 10, scale: 3, default: "0.0", null: false
    t.bigint "consumable_id", null: false
    t.string "consumable_type", null: false
    t.datetime "created_at", null: false
    t.bigint "day_partition_id", null: false
    t.decimal "fat", precision: 10, scale: 3, default: "0.0", null: false
    t.decimal "fat_saturated", precision: 10, scale: 3, default: "0.0", null: false
    t.decimal "fiber", precision: 10, scale: 3, default: "0.0", null: false
    t.bigint "journal_day_id", null: false
    t.integer "kcal", default: 0, null: false
    t.decimal "protein", precision: 10, scale: 3, default: "0.0", null: false
    t.datetime "updated_at", null: false
    t.index ["day_partition_id"], name: "index_meals_on_day_partition_id"
    t.index ["journal_day_id"], name: "index_meals_on_journal_day_id"
  end

  create_table "portions", force: :cascade do |t|
    t.integer "amount", null: false
    t.decimal "carbs", precision: 10, scale: 3, default: "0.0", null: false
    t.decimal "carbs_sugar_part", precision: 10, scale: 3, default: "0.0", null: false
    t.datetime "created_at", null: false
    t.decimal "fat", precision: 10, scale: 3, default: "0.0", null: false
    t.decimal "fat_saturated", precision: 10, scale: 3, default: "0.0", null: false
    t.decimal "fiber", precision: 10, scale: 3, default: "0.0", null: false
    t.bigint "food_id", null: false
    t.integer "kcal", default: 0, null: false
    t.string "name", null: false
    t.decimal "protein", precision: 10, scale: 3, default: "0.0", null: false
    t.datetime "updated_at", null: false
    t.index ["food_id", "amount"], name: "index_portions_on_food_id_and_amount", unique: true
    t.index ["food_id", "name"], name: "index_portions_on_food_id_and_name", unique: true
    t.index ["food_id"], name: "index_portions_on_food_id"
  end

  create_table "recipe_ingredients", force: :cascade do |t|
    t.decimal "amount", null: false
    t.decimal "carbs", precision: 10, scale: 3, default: "0.0", null: false
    t.decimal "carbs_sugar_part", precision: 10, scale: 3, default: "0.0", null: false
    t.datetime "created_at", null: false
    t.decimal "fat", precision: 10, scale: 3, default: "0.0", null: false
    t.decimal "fat_saturated", precision: 10, scale: 3, default: "0.0", null: false
    t.decimal "fiber", precision: 10, scale: 3, default: "0.0", null: false
    t.integer "kcal", default: 0, null: false
    t.string "measure", default: "unit", null: false
    t.bigint "portion_id"
    t.decimal "protein", precision: 10, scale: 3, default: "0.0", null: false
    t.bigint "recipe_id", null: false
    t.datetime "updated_at", null: false
    t.index ["portion_id"], name: "index_recipe_ingredients_on_portion_id"
    t.index ["recipe_id"], name: "index_recipe_ingredients_on_recipe_id"
  end

  create_table "recipes", force: :cascade do |t|
    t.datetime "archived_at"
    t.decimal "carbs", precision: 10, scale: 3, default: "0.0", null: false
    t.decimal "carbs_sugar_part", precision: 10, scale: 3, default: "0.0", null: false
    t.datetime "created_at", null: false
    t.decimal "fat", precision: 10, scale: 3, default: "0.0", null: false
    t.decimal "fat_saturated", precision: 10, scale: 3, default: "0.0", null: false
    t.decimal "fiber", precision: 10, scale: 3, default: "0.0", null: false
    t.integer "kcal", default: 0, null: false
    t.string "name", null: false
    t.decimal "protein", precision: 10, scale: 3, default: "0.0", null: false
    t.integer "servings", default: 1, null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.boolean "vegan", default: false, null: false
    t.index ["user_id"], name: "index_recipes_on_user_id"
  end

  create_table "solid_queue_blocked_executions", force: :cascade do |t|
    t.string "concurrency_key", null: false
    t.datetime "created_at", null: false
    t.datetime "expires_at", null: false
    t.bigint "job_id", null: false
    t.integer "priority", default: 0, null: false
    t.string "queue_name", null: false
    t.index ["concurrency_key", "priority", "job_id"], name: "index_solid_queue_blocked_executions_for_release"
    t.index ["expires_at", "concurrency_key"], name: "index_solid_queue_blocked_executions_for_maintenance"
    t.index ["job_id"], name: "index_solid_queue_blocked_executions_on_job_id", unique: true
  end

  create_table "solid_queue_claimed_executions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "job_id", null: false
    t.bigint "process_id"
    t.index ["job_id"], name: "index_solid_queue_claimed_executions_on_job_id", unique: true
    t.index ["process_id", "job_id"], name: "index_solid_queue_claimed_executions_on_process_id_and_job_id"
  end

  create_table "solid_queue_failed_executions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "error"
    t.bigint "job_id", null: false
    t.index ["job_id"], name: "index_solid_queue_failed_executions_on_job_id", unique: true
  end

  create_table "solid_queue_jobs", force: :cascade do |t|
    t.string "active_job_id"
    t.text "arguments"
    t.string "class_name", null: false
    t.string "concurrency_key"
    t.datetime "created_at", null: false
    t.datetime "finished_at"
    t.integer "priority", default: 0, null: false
    t.string "queue_name", null: false
    t.datetime "scheduled_at"
    t.datetime "updated_at", null: false
    t.index ["active_job_id"], name: "index_solid_queue_jobs_on_active_job_id"
    t.index ["class_name"], name: "index_solid_queue_jobs_on_class_name"
    t.index ["finished_at"], name: "index_solid_queue_jobs_on_finished_at"
    t.index ["queue_name", "finished_at"], name: "index_solid_queue_jobs_for_filtering"
    t.index ["scheduled_at", "finished_at"], name: "index_solid_queue_jobs_for_alerting"
  end

  create_table "solid_queue_pauses", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "queue_name", null: false
    t.index ["queue_name"], name: "index_solid_queue_pauses_on_queue_name", unique: true
  end

  create_table "solid_queue_processes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "hostname"
    t.string "kind", null: false
    t.datetime "last_heartbeat_at", null: false
    t.text "metadata"
    t.string "name", null: false
    t.integer "pid", null: false
    t.bigint "supervisor_id"
    t.index ["last_heartbeat_at"], name: "index_solid_queue_processes_on_last_heartbeat_at"
    t.index ["name", "supervisor_id"], name: "index_solid_queue_processes_on_name_and_supervisor_id", unique: true
    t.index ["supervisor_id"], name: "index_solid_queue_processes_on_supervisor_id"
  end

  create_table "solid_queue_ready_executions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "job_id", null: false
    t.integer "priority", default: 0, null: false
    t.string "queue_name", null: false
    t.index ["job_id"], name: "index_solid_queue_ready_executions_on_job_id", unique: true
    t.index ["priority", "job_id"], name: "index_solid_queue_poll_all"
    t.index ["queue_name", "priority", "job_id"], name: "index_solid_queue_poll_by_queue"
  end

  create_table "solid_queue_recurring_executions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "job_id", null: false
    t.datetime "run_at", null: false
    t.string "task_key", null: false
    t.index ["job_id"], name: "index_solid_queue_recurring_executions_on_job_id", unique: true
    t.index ["task_key", "run_at"], name: "index_solid_queue_recurring_executions_on_task_key_and_run_at", unique: true
  end

  create_table "solid_queue_recurring_tasks", force: :cascade do |t|
    t.text "arguments"
    t.string "class_name"
    t.string "command", limit: 2048
    t.datetime "created_at", null: false
    t.text "description"
    t.string "key", null: false
    t.integer "priority", default: 0
    t.string "queue_name"
    t.string "schedule", null: false
    t.boolean "static", default: true, null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_solid_queue_recurring_tasks_on_key", unique: true
    t.index ["static"], name: "index_solid_queue_recurring_tasks_on_static"
  end

  create_table "solid_queue_scheduled_executions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "job_id", null: false
    t.integer "priority", default: 0, null: false
    t.string "queue_name", null: false
    t.datetime "scheduled_at", null: false
    t.index ["job_id"], name: "index_solid_queue_scheduled_executions_on_job_id", unique: true
    t.index ["scheduled_at", "priority", "job_id"], name: "index_solid_queue_dispatch_all"
  end

  create_table "solid_queue_semaphores", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "expires_at", null: false
    t.string "key", null: false
    t.datetime "updated_at", null: false
    t.integer "value", default: 1, null: false
    t.index ["expires_at"], name: "index_solid_queue_semaphores_on_expires_at"
    t.index ["key", "value"], name: "index_solid_queue_semaphores_on_key_and_value"
    t.index ["key"], name: "index_solid_queue_semaphores_on_key", unique: true
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "locale", default: "en", null: false
    t.string "password_digest"
    t.string "reset_password_challenge"
    t.datetime "reset_password_link_sent_at"
    t.string "role", default: "user", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "day_partitions", "users"
  add_foreign_key "foods", "users"
  add_foreign_key "journal_days", "users"
  add_foreign_key "meal_ingredients", "meals"
  add_foreign_key "meal_ingredients", "portions"
  add_foreign_key "meals", "day_partitions"
  add_foreign_key "meals", "journal_days"
  add_foreign_key "portions", "foods"
  add_foreign_key "recipe_ingredients", "recipes"
  add_foreign_key "recipes", "users"
  add_foreign_key "solid_queue_blocked_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_claimed_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_failed_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_ready_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_recurring_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_scheduled_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
end
