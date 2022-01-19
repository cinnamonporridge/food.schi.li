WITH default_amount AS (
  SELECT 100::FLOAT AS value
),

with_target_nutrition_facts AS (
  SELECT mi.id                                       AS meal_ingredient_id
       , mi.meal_id                                  AS meal_id
       , mi.portion_id                               AS meal_portion_id
       , mi.amount                                   AS meal_amount
       , mi.measure                                  AS meal_measure
       , (mi.amount / da.value) * f.kcal             AS meal_target_kcal
       , (mi.amount / da.value) * f.carbs            AS meal_target_carbs
       , (mi.amount / da.value) * f.carbs_sugar_part AS meal_target_carbs_sugar_part
       , (mi.amount / da.value) * f.protein          AS meal_target_protein
       , (mi.amount / da.value) * f.fat              AS meal_target_fat
       , (mi.amount / da.value) * f.fat_saturated    AS meal_target_fat_saturated
       , (mi.amount / da.value) * f.fiber            AS meal_target_fiber
       , mi.created_at                               AS meal_created_at
    FROM meal_ingredients mi
   CROSS JOIN default_amount da
   INNER JOIN portions p ON p.id = mi.portion_id
   INNER JOIN foods f    ON f.id = p.food_id
 ),

 with_rounded_nutrition_facts AS (
   SELECT meal_ingredient_id
        , meal_id
        , meal_portion_id
        , meal_amount
        , meal_measure
        , ROUND(meal_target_kcal::NUMERIC, 0)             AS meal_target_kcal
        , ROUND(meal_target_carbs::NUMERIC, 3)            AS meal_target_carbs
        , ROUND(meal_target_carbs_sugar_part::NUMERIC, 3) AS meal_target_carbs_sugar_part
        , ROUND(meal_target_protein::NUMERIC, 3)          AS meal_target_protein
        , ROUND(meal_target_fat::NUMERIC, 3)              AS meal_target_fat
        , ROUND(meal_target_fat_saturated::NUMERIC, 3)    AS meal_target_fat_saturated
        , ROUND(meal_target_fiber::NUMERIC, 3)            AS meal_target_fiber
        , meal_created_at
     FROM with_target_nutrition_facts
 )

 INSERT INTO meal_ingredients (
     id
   , meal_id
   , portion_id
   , amount
   , measure
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
 SELECT meal_ingredient_id
      , meal_id
      , meal_portion_id
      , meal_amount
      , meal_measure
      , meal_target_kcal
      , meal_target_carbs
      , meal_target_carbs_sugar_part
      , meal_target_protein
      , meal_target_fat
      , meal_target_fat_saturated
      , meal_target_fiber
      , meal_created_at
      , NOW() AS updated_at
   FROM with_rounded_nutrition_facts
     ON CONFLICT (id)
     DO UPDATE SET kcal = EXCLUDED.kcal
                 , carbs = EXCLUDED.carbs
                 , carbs_sugar_part = EXCLUDED.carbs_sugar_part
                 , protein = EXCLUDED.protein
                 , fat = EXCLUDED.fat
                 , fat_saturated = EXCLUDED.fat_saturated
                 , fiber = EXCLUDED.fiber
                 , updated_at = EXCLUDED.updated_at
;
