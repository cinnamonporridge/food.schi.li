WITH default_amount AS (
  SELECT 100::FLOAT AS value
),

with_target_nutrition_facts AS (
  SELECT i.id                                        AS ingredient_id
       , i.recipe_id                                 AS ingredient_recipe_id
       , i.portion_id                                AS ingredient_portion_id
       , i.amount                                    AS ingredient_amount
       , (i.amount / da.value) * f.kcal              AS ingredient_target_kcal
       , (i.amount / da.value) * f.carbs             AS ingredient_target_carbs
       , (i.amount / da.value) * f.carbs_sugar_part  AS ingredient_target_carbs_sugar_part
       , (i.amount / da.value) * f.protein           AS ingredient_target_protein
       , (i.amount / da.value) * f.fat               AS ingredient_target_fat
       , (i.amount / da.value) * f.fat_saturated     AS ingredient_target_fat_saturated
       , (i.amount / da.value) * f.fiber             AS ingredient_target_fiber
       , i.measure                                   AS ingredient_measure
       , i.created_at                                AS ingredient_created_at
    FROM ingredients i
   CROSS JOIN default_amount da
   INNER JOIN portions p   ON p.id = i.portion_id
   INNER JOIN foods f      ON f.id = p.food_id
),

with_rounded_target_nutrution_facts AS (
  SELECT ingredient_id
       , ingredient_recipe_id
       , ingredient_portion_id
       , ingredient_amount
       , ROUND(ingredient_target_kcal::NUMERIC, 0)              AS ingredient_target_kcal
       , ROUND(ingredient_target_carbs::NUMERIC, 3)             AS ingredient_target_carbs
       , ROUND(ingredient_target_carbs_sugar_part::NUMERIC, 3)  AS ingredient_target_carbs_sugar_part
       , ROUND(ingredient_target_protein::NUMERIC, 3)           AS ingredient_target_protein
       , ROUND(ingredient_target_fat::NUMERIC, 3)               AS ingredient_target_fat
       , ROUND(ingredient_target_fat_saturated::NUMERIC, 3)     AS ingredient_target_fat_saturated
       , ROUND(ingredient_target_fiber::NUMERIC, 3)             AS ingredient_target_fiber
       , ingredient_measure
       , ingredient_created_at
    FROM with_target_nutrition_facts
)
INSERT INTO ingredients (
    id
  , recipe_id
  , portion_id
  , amount
  , kcal
  , carbs
  , carbs_sugar_part
  , protein
  , fat
  , fat_saturated
  , fiber
  , measure
  , created_at
  , updated_at
)
SELECT ingredient_id
     , ingredient_recipe_id
     , ingredient_portion_id
     , ingredient_amount
     , ingredient_target_kcal
     , ingredient_target_carbs
     , ingredient_target_carbs_sugar_part
     , ingredient_target_protein
     , ingredient_target_fat
     , ingredient_target_fat_saturated
     , ingredient_target_fiber
     , ingredient_measure
     , ingredient_created_at
     , NOW() AS updated_at
  FROM with_rounded_target_nutrution_facts
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
