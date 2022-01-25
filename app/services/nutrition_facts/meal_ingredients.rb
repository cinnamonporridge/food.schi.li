class NutritionFacts::MealIngredients < NutritionFacts::Base
  private

  def update_sql
    <<~SQL.squish
      UPDATE meal_ingredients mi
         SET kcal             = target.kcal
           , carbs            = target.carbs
           , carbs_sugar_part = target.carbs_sugar_part
           , protein          = target.protein
           , fat              = target.fat
           , fat_saturated    = target.fat_saturated
           , fiber            = target.fiber
        FROM (
                SELECT mi.id
                     , ROUND(((mi.amount / d.default_amount) * f.kcal)             , 0) AS kcal
                     , ROUND(((mi.amount / d.default_amount) * f.carbs)            , 3) AS carbs
                     , ROUND(((mi.amount / d.default_amount) * f.carbs_sugar_part) , 3) AS carbs_sugar_part
                     , ROUND(((mi.amount / d.default_amount) * f.protein)          , 3) AS protein
                     , ROUND(((mi.amount / d.default_amount) * f.fat)              , 3) AS fat
                     , ROUND(((mi.amount / d.default_amount) * f.fat_saturated)    , 3) AS fat_saturated
                     , ROUND(((mi.amount / d.default_amount) * f.fiber)            , 3) AS fiber
                  FROM meal_ingredients mi
                 CROSS JOIN (SELECT 100 AS default_amount) AS d
                 INNER JOIN portions p ON p.id = mi.portion_id
                 INNER JOIN foods f    ON f.id = p.food_id
              ) target
       WHERE mi.id = target.id
    SQL
  end
end
