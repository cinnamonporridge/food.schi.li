UPDATE meals
   SET kcal              = meal_ingredients.kcal_sum
     , carbs             = meal_ingredients.carbs_sum
     , carbs_sugar_part  = meal_ingredients.carbs_sugar_part_sum
     , protein           = meal_ingredients.protein_sum
     , fat               = meal_ingredients.fat_sum
     , fat_saturated     = meal_ingredients.fat_saturated_sum
     , fiber             = meal_ingredients.fiber_sum
  FROM ( SELECT meal_id
              , sum(kcal)              AS kcal_sum
              , sum(carbs)             AS carbs_sum
              , sum(carbs_sugar_part)  AS carbs_sugar_part_sum
              , sum(protein)           AS protein_sum
              , sum(fat)               AS fat_sum
              , sum(fat_saturated)     AS fat_saturated_sum
              , sum(fiber)             AS fiber_sum
           FROM meal_ingredients
       GROUP BY meal_id ) AS meal_ingredients
 WHERE meals.id = meal_ingredients.meal_id
