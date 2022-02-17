class NutritionFacts::MealIngredients < NutritionFacts::Base
  private

  def model_to_column_filter_mapping
    {
      Food: 'f.id',
      Portion: 'p.id',
      MealIngredient: 'mi.id',
      Meal: 'm.id',
      User: 'jd.user_id'
    }
  end

  def update_sql
    <<~SQL.squish
      WITH target AS (
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
         INNER JOIN meals m         ON m.id = mi.meal_id
         INNER JOIN journal_days jd ON jd.id = m.journal_day_id
         INNER JOIN portions p      ON p.id = mi.portion_id
         INNER JOIN foods f         ON f.id = p.food_id
         WHERE 0 = 0
           AND #{filter}
      )
      UPDATE meal_ingredients mi
         SET kcal             = target.kcal
           , carbs            = target.carbs
           , carbs_sugar_part = target.carbs_sugar_part
           , protein          = target.protein
           , fat              = target.fat
           , fat_saturated    = target.fat_saturated
           , fiber            = target.fiber
        FROM target
       WHERE mi.id = target.id
    SQL
  end
end
