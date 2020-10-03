WITH default_amount AS (
  SELECT 100::FLOAT AS value
),

with_target_nutrition_facts AS (
  SELECT m.id                                       AS meal_id
       , m.journal_day_id                           AS meal_journal_day_id
       , m.portion_id                               AS meal_portion_id
       , m.amount                                   AS meal_amount
       , m.measure                                  AS meal_measure
       , m.measure_unit                             AS meal_measure_unit
       , (m.amount / da.value) * n.kcal             AS meal_target_kcal
       , (m.amount / da.value) * n.carbs            AS meal_target_carbs
       , (m.amount / da.value) * n.carbs_sugar_part AS meal_target_carbs_sugar_part
       , (m.amount / da.value) * n.protein          AS meal_target_protein
       , (m.amount / da.value) * n.fat              AS meal_target_fat
       , (m.amount / da.value) * n.fat_saturated    AS meal_target_fat_saturated
       , (m.amount / da.value) * n.fiber            AS meal_target_fiber
       , m.created_at                               AS meal_created_at
    FROM meals m
   CROSS JOIN default_amount da
   INNER JOIN portions p ON p.id = m.portion_id
   INNER JOIN nutritions n ON n.id = p.nutrition_id
 ),

 with_rounded_nutrition_facts AS (
   SELECT meal_id
        , meal_journal_day_id
        , meal_portion_id
        , meal_amount
        , meal_measure
        , meal_measure_unit
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
 
 INSERT INTO meals (
     id
   , journal_day_id
   , portion_id
   , amount
   , measure
   , measure_unit
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
 SELECT meal_id
      , meal_journal_day_id
      , meal_portion_id
      , meal_amount
      , meal_measure
      , meal_measure_unit
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
