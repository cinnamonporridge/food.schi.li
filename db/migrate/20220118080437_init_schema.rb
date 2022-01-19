class InitSchema < ActiveRecord::Migration[7.0] # rubocop:disable Metrics/ClassLength
  def up # rubocop:disable Metrics/AbcSize
    # These are extensions that must be enabled in order to support this database
    enable_extension 'plpgsql'
    create_table 'foods' do |t|
      t.string 'name', null: false
      t.integer 'kcal', null: false
      t.decimal 'carbs', precision: 10, scale: 3, null: false
      t.decimal 'carbs_sugar_part', precision: 10, scale: 3, null: false
      t.decimal 'protein', precision: 10, scale: 3, null: false
      t.decimal 'fat', precision: 10, scale: 3, null: false
      t.decimal 'fat_saturated', precision: 10, scale: 3, null: false
      t.decimal 'fiber', precision: 10, scale: 3, null: false
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.boolean 'vegan', default: false, null: false
      t.string 'unit', default: 'gram', null: false
      t.bigint 'user_id', null: false
      t.index ['name'], name: 'index_foods_on_name', unique: true
      t.index ['user_id'], name: 'index_foods_on_user_id'
    end
    create_table 'ingredients' do |t|
      t.bigint 'recipe_id', null: false
      t.bigint 'portion_id'
      t.decimal 'amount', null: false
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.integer 'kcal', default: 0, null: false
      t.decimal 'carbs', precision: 10, scale: 3, default: '0.0', null: false
      t.decimal 'carbs_sugar_part', precision: 10, scale: 3, default: '0.0', null: false
      t.decimal 'protein', precision: 10, scale: 3, default: '0.0', null: false
      t.decimal 'fat', precision: 10, scale: 3, default: '0.0', null: false
      t.decimal 'fat_saturated', precision: 10, scale: 3, default: '0.0', null: false
      t.decimal 'fiber', precision: 10, scale: 3, default: '0.0', null: false
      t.string 'measure', default: 'unit', null: false
      t.index ['portion_id'], name: 'index_ingredients_on_portion_id'
      t.index ['recipe_id'], name: 'index_ingredients_on_recipe_id'
    end
    create_table 'journal_days' do |t|
      t.bigint 'user_id', null: false
      t.date 'date', null: false
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.integer 'kcal', default: 0, null: false
      t.decimal 'carbs', precision: 10, scale: 3, default: '0.0', null: false
      t.decimal 'carbs_sugar_part', precision: 10, scale: 3, default: '0.0', null: false
      t.decimal 'protein', precision: 10, scale: 3, default: '0.0', null: false
      t.decimal 'fat', precision: 10, scale: 3, default: '0.0', null: false
      t.decimal 'fat_saturated', precision: 10, scale: 3, default: '0.0', null: false
      t.decimal 'fiber', precision: 10, scale: 3, default: '0.0', null: false
      t.index %w[date user_id], name: 'index_journal_days_on_date_and_user_id', unique: true
      t.index ['user_id'], name: 'index_journal_days_on_user_id'
    end
    create_table 'meal_ingredients' do |t|
      t.bigint 'journal_day_id'
      t.bigint 'portion_id'
      t.bigint 'recipe_id'
      t.decimal 'amount'
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.integer 'kcal', default: 0, null: false
      t.decimal 'carbs', precision: 10, scale: 3, default: '0.0', null: false
      t.decimal 'carbs_sugar_part', precision: 10, scale: 3, default: '0.0', null: false
      t.decimal 'protein', precision: 10, scale: 3, default: '0.0', null: false
      t.decimal 'fat', precision: 10, scale: 3, default: '0.0', null: false
      t.decimal 'fat_saturated', precision: 10, scale: 3, default: '0.0', null: false
      t.decimal 'fiber', precision: 10, scale: 3, default: '0.0', null: false
      t.string 'measure', default: 'unit', null: false
      t.index ['journal_day_id'], name: 'index_meal_ingredients_on_journal_day_id'
      t.index ['portion_id'], name: 'index_meal_ingredients_on_portion_id'
      t.index ['recipe_id'], name: 'index_meal_ingredients_on_recipe_id'
    end
    create_table 'portions' do |t|
      t.string 'name', null: false
      t.bigint 'food_id', null: false
      t.integer 'amount', null: false
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.integer 'kcal', default: 0, null: false
      t.decimal 'carbs', precision: 10, scale: 3, default: '0.0', null: false
      t.decimal 'carbs_sugar_part', precision: 10, scale: 3, default: '0.0', null: false
      t.decimal 'protein', precision: 10, scale: 3, default: '0.0', null: false
      t.decimal 'fat', precision: 10, scale: 3, default: '0.0', null: false
      t.decimal 'fat_saturated', precision: 10, scale: 3, default: '0.0', null: false
      t.decimal 'fiber', precision: 10, scale: 3, default: '0.0', null: false
      t.index %w[food_id amount], name: 'index_portions_on_food_id_and_amount', unique: true
      t.index %w[food_id name], name: 'index_portions_on_food_id_and_name', unique: true
      t.index ['food_id'], name: 'index_portions_on_food_id'
    end
    create_table 'recipes' do |t|
      t.string 'name', null: false
      t.integer 'servings', default: 1, null: false
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.boolean 'vegan', default: false, null: false
      t.integer 'kcal', default: 0, null: false
      t.decimal 'carbs', precision: 10, scale: 3, default: '0.0', null: false
      t.decimal 'carbs_sugar_part', precision: 10, scale: 3, default: '0.0', null: false
      t.decimal 'protein', precision: 10, scale: 3, default: '0.0', null: false
      t.decimal 'fat', precision: 10, scale: 3, default: '0.0', null: false
      t.decimal 'fat_saturated', precision: 10, scale: 3, default: '0.0', null: false
      t.decimal 'fiber', precision: 10, scale: 3, default: '0.0', null: false
      t.bigint 'user_id', null: false
      t.index ['user_id'], name: 'index_recipes_on_user_id'
    end
    create_table 'users', id: :serial do |t|
      t.string 'email', null: false
      t.string 'password_digest'
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.datetime 'reset_password_link_sent_at'
      t.string 'reset_password_challenge'
      t.datetime 'magic_link_sent_at'
      t.string 'magic_link_challenge'
      t.boolean 'is_admin', default: false, null: false
    end
    add_foreign_key 'foods', 'users'
    add_foreign_key 'ingredients', 'recipes'
    add_foreign_key 'journal_days', 'users'
    add_foreign_key 'meal_ingredients', 'journal_days'
    add_foreign_key 'meal_ingredients', 'portions'
    add_foreign_key 'meal_ingredients', 'recipes'
    add_foreign_key 'portions', 'foods'
    add_foreign_key 'recipes', 'users'
  end

  def down
    raise ActiveRecord::IrreversibleMigration, 'The initial migration is not revertable'
  end
end
