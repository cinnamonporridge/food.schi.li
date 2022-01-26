class NutritionFacts::Meals < NutritionFacts::Base
  private

  def update_sql
    <<~SQL.squish
      WITH with_nutrition_facts AS (
              SELECT m.id                                                AS meal_id
                   , (mi.amount / d.default_amount) * f.kcal             AS kcal
                   , (mi.amount / d.default_amount) * f.carbs            AS carbs
                   , (mi.amount / d.default_amount) * f.carbs_sugar_part AS carbs_sugar_part
                   , (mi.amount / d.default_amount) * f.protein          AS protein
                   , (mi.amount / d.default_amount) * f.fat              AS fat
                   , (mi.amount / d.default_amount) * f.fat_saturated    AS fat_saturated
                   , (mi.amount / d.default_amount) * f.fiber            AS fiber
                FROM meals m
               CROSS JOIN (SELECT 100 AS default_amount) AS d
               INNER JOIN meal_ingredients mi ON mi.meal_id = m.id
               INNER JOIN portions p          ON p.id = mi.portion_id
               INNER JOIN foods f             ON f.id = p.food_id
               WHERE 0 = 0
                 AND f.user_id = #{@user.id}
      )
      , with_summed_nutrition_facts AS (
        SELECT meal_id                           AS meal_id
             , ROUND(sum(kcal)              , 0) AS kcal
             , ROUND(sum(carbs)             , 3) AS carbs
             , ROUND(sum(carbs_sugar_part)  , 3) AS carbs_sugar_part
             , ROUND(sum(protein)           , 3) AS protein
             , ROUND(sum(fat)               , 3) AS fat
             , ROUND(sum(fat_saturated)     , 3) AS fat_saturated
             , ROUND(sum(fiber)             , 3) AS fiber
          FROM with_nutrition_facts
         GROUP BY meal_id
      )
      UPDATE meals
         SET kcal              = target.kcal
           , carbs             = target.carbs
           , carbs_sugar_part  = target.carbs_sugar_part
           , protein           = target.protein
           , fat               = target.fat
           , fat_saturated     = target.fat_saturated
           , fiber             = target.fiber
        FROM with_summed_nutrition_facts target
       WHERE meals.id = target.meal_id
    SQL
  end
end
