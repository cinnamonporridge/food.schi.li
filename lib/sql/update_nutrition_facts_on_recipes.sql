WITH default_amount AS (
  SELECT 100::FLOAT AS value
),

with_nutrition_facts AS (
  SELECT r.id                                       AS recipe_id
       , (i.amount / da.value) * f.kcal             AS recipe_target_kcal
       , (i.amount / da.value) * f.carbs            AS recipe_target_carbs
       , (i.amount / da.value) * f.carbs_sugar_part AS recipe_target_carbs_sugar_part
       , (i.amount / da.value) * f.protein          AS recipe_target_protein
       , (i.amount / da.value) * f.fat              AS recipe_target_fat
       , (i.amount / da.value) * f.fat_saturated    AS recipe_target_fat_saturated
       , (i.amount / da.value) * f.fiber            AS recipe_target_fiber
    FROM recipes r
   CROSS JOIN default_amount da
   INNER JOIN ingredients i ON i.recipe_id = r.id
   INNER JOIN portions p    ON p.id = i.portion_id
   INNER JOIN foods f       ON f.id = p.food_id
),

with_summed_nutrition_facts AS (
  SELECT recipe_id                           AS recipe_id
       , sum(recipe_target_kcal)             AS recipe_target_kcal_sum
       , sum(recipe_target_carbs)            AS recipe_target_carbs_sum
       , sum(recipe_target_carbs_sugar_part) AS recipe_target_carbs_sugar_part_sum
       , sum(recipe_target_protein)          AS recipe_target_protein_sum
       , sum(recipe_target_fat)              AS recipe_target_fat_sum
       , sum(recipe_target_fat_saturated)    AS recipe_target_fat_saturated_sum
       , sum(recipe_target_fiber)            AS recipe_target_fiber_sum
    FROM with_nutrition_facts
   GROUP BY recipe_id
),

with_rounded_target_nutrution_facts AS (
SELECT recipe_id
     , ROUND(recipe_target_kcal_sum::NUMERIC, 0)             AS recipe_target_kcal
     , ROUND(recipe_target_carbs_sum::NUMERIC, 3)            AS recipe_target_carbs
     , ROUND(recipe_target_carbs_sugar_part_sum::NUMERIC, 3) AS recipe_target_carbs_sugar_part
     , ROUND(recipe_target_protein_sum::NUMERIC, 3)          AS recipe_target_protein
     , ROUND(recipe_target_fat_sum::NUMERIC, 3)              AS recipe_target_fat
     , ROUND(recipe_target_fat_saturated_sum::NUMERIC, 3)    AS recipe_target_fat_saturated
     , ROUND(recipe_target_fiber_sum::NUMERIC, 3)            AS recipe_target_fiber
  FROM with_summed_nutrition_facts
)
INSERT INTO recipes (
    id
  , name
  , servings
  , vegan
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
SELECT r.id
     , r.name
     , r.servings
     , r.vegan
     , tnf.recipe_target_kcal
     , tnf.recipe_target_carbs
     , tnf.recipe_target_carbs_sugar_part
     , tnf.recipe_target_protein
     , tnf.recipe_target_fat
     , tnf.recipe_target_fat_saturated
     , tnf.recipe_target_fiber
     , r.created_at
     , NOW() AS updated_at
  FROM with_rounded_target_nutrution_facts tnf
 INNER JOIN recipes r ON r.id = tnf.recipe_id
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
