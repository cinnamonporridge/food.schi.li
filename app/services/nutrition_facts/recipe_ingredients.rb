class NutritionFacts::RecipeIngredients < NutritionFacts::Base
  private

  def update_sql
    <<~SQL.squish
      UPDATE recipe_ingredients ri
         SET kcal             = target.kcal
           , carbs            = target.carbs
           , carbs_sugar_part = target.carbs_sugar_part
           , protein          = target.protein
           , fat              = target.fat
           , fat_saturated    = target.fat_saturated
           , fiber            = target.fiber
        FROM (  SELECT ri.id
                     , ROUND(((ri.amount / d.default_amount) * f.kcal)             , 0) AS kcal
                     , ROUND(((ri.amount / d.default_amount) * f.carbs)            , 3) AS carbs
                     , ROUND(((ri.amount / d.default_amount) * f.carbs_sugar_part) , 3) AS carbs_sugar_part
                     , ROUND(((ri.amount / d.default_amount) * f.protein)          , 3) AS protein
                     , ROUND(((ri.amount / d.default_amount) * f.fat)              , 3) AS fat
                     , ROUND(((ri.amount / d.default_amount) * f.fat_saturated)    , 3) AS fat_saturated
                     , ROUND(((ri.amount / d.default_amount) * f.fiber)            , 3) AS fiber
                  FROM recipe_ingredients ri
                 CROSS JOIN (SELECT 100 AS default_amount) AS d
                 INNER JOIN portions p ON p.id = ri.portion_id
                 INNER JOIN foods f    ON f.id = p.food_id
                 WHERE 0 = 0
                   AND f.user_id = #{@user.id}
              ) target
       WHERE ri.id = target.id
    SQL
  end
end
