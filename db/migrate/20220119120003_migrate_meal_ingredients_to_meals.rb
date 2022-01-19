class MigrateMealIngredientsToMeals < ActiveRecord::Migration[7.0]
  def up
    execute upsert_meals_sql
    execute upsert_meal_ingredients_sql
  end

  def down
    # not intended
  end

  private

  def upsert_meals_sql
    <<~SQL.squish
      WITH consumable_meal_ingredients AS (
        SELECT mi.journal_day_id
             , CASE WHEN mi.recipe_id IS NOT NULL THEN mi.recipe_id ELSE mi.portion_id END AS consumable_id
             , CASE WHEN mi.recipe_id IS NOT NULL THEN 'Recipe'     ELSE 'Portion' END     AS consumable_type
          FROM meal_ingredients mi
        )

      INSERT INTO meals (
          journal_day_id
        , consumable_id
        , consumable_type
        , kcal
        , carbs
        , carbs_sugar_part
        , protein
        , fat
        , fat_saturated
        , fiber
        , created_at
        , updated_at
      )

      SELECT DISTINCT
             journal_day_id
           , consumable_id
           , consumable_type
           , 0                AS kcal
           , 0.0              AS carbs
           , 0.0              AS carbs_sugar_part
           , 0.0              AS protein
           , 0.0              AS fat
           , 0.0              AS fat_saturated
           , 0.0              AS fiber
           , NOW()            AS created_at
           , NOW()            AS updated_at
        FROM consumable_meal_ingredients
          ON CONFLICT (journal_day_id, consumable_id, consumable_type)
          DO
      UPDATE SET updated_at = EXCLUDED.updated_at
    SQL
  end

  def upsert_meal_ingredients_sql
    <<~SQL.squish
      UPDATE meal_ingredients
         SET meal_id = t.meal_id
        FROM ( WITH consumable_meal_ingredients AS (
             SELECT mi.id                                                                       AS meal_ingredient_id
                  , mi.journal_day_id
                  , CASE WHEN mi.recipe_id IS NOT NULL THEN mi.recipe_id ELSE mi.portion_id END AS consumable_id
                  , CASE WHEN mi.recipe_id IS NOT NULL THEN 'Recipe'     ELSE 'Portion'     END AS consumable_type
               FROM meal_ingredients mi
              )
              SELECT cmi.*
                   , m.id     AS meal_id
                FROM consumable_meal_ingredients cmi
               INNER JOIN meals m ON m.journal_day_id = cmi.journal_day_id
                                 AND m.consumable_id = cmi.consumable_id
                                 AND m.consumable_type = cmi.consumable_type ) t
       WHERE id = meal_ingredient_id
    SQL
  end
end
