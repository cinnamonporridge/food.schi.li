class NutritionFacts::Recipes < NutritionFacts::Base
  private

  def model_to_column_filter_mapping
    {
      'RecipeIngredient': 'ri.id',
      'Recipe': 'r.id',
      'User': 'r.user_id',
      'Portion': 'p.id',
      'Food': 'f.id'
    }
  end

  def update_sql
    <<~SQL.squish
      WITH with_nutrition_facts AS (
        SELECT r.id                                                AS recipe_id
             , (ri.amount / d.default_amount) * f.kcal             AS kcal
             , (ri.amount / d.default_amount) * f.carbs            AS carbs
             , (ri.amount / d.default_amount) * f.carbs_sugar_part AS carbs_sugar_part
             , (ri.amount / d.default_amount) * f.protein          AS protein
             , (ri.amount / d.default_amount) * f.fat              AS fat
             , (ri.amount / d.default_amount) * f.fat_saturated    AS fat_saturated
             , (ri.amount / d.default_amount) * f.fiber            AS fiber
          FROM recipes r
         CROSS JOIN (SELECT 100 AS default_amount) AS d
          LEFT OUTER JOIN recipe_ingredients ri ON ri.recipe_id = r.id
          LEFT OUTER JOIN portions p            ON p.id = ri.portion_id
          LEFT OUTER JOIN foods f               ON f.id = p.food_id
         WHERE 0 = 0
           AND #{filter}
      )
      , target AS (
        SELECT recipe_id                         AS recipe_id
             , COALESCE(ROUND(sum(kcal)              , 0), 0) AS kcal
             , COALESCE(ROUND(sum(carbs)             , 3), 0) AS carbs
             , COALESCE(ROUND(sum(carbs_sugar_part)  , 3), 0) AS carbs_sugar_part
             , COALESCE(ROUND(sum(protein)           , 3), 0) AS protein
             , COALESCE(ROUND(sum(fat)               , 3), 0) AS fat
             , COALESCE(ROUND(sum(fat_saturated)     , 3), 0) AS fat_saturated
             , COALESCE(ROUND(sum(fiber)             , 3), 0) AS fiber
          FROM with_nutrition_facts
         GROUP BY recipe_id
      )
      UPDATE recipes r
         SET kcal             = target.kcal
           , carbs            = target.carbs
           , carbs_sugar_part = target.carbs_sugar_part
           , protein          = target.protein
           , fat              = target.fat
           , fat_saturated    = target.fat_saturated
           , fiber            = target.fiber
        FROM target
       WHERE r.id = target.recipe_id
    SQL
  end
end
