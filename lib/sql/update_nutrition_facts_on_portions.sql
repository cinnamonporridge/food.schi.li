WITH default_amount AS (
  SELECT 100::FLOAT AS value
),

portions_with_nutrition_facts AS (
  SELECT p.id                 AS portion_id
       , da.value             AS default_amount
       , f.id                 AS food_id
       , f.name               AS food_name
       , f.kcal               AS food_kcal
       , f.carbs              AS food_carbs
       , f.carbs_sugar_part   AS food_carbs_sugar_part
       , f.protein            AS food_protein
       , f.fat                AS food_fat
       , f.fat_saturated      AS food_fat_saturated
       , f.fiber              AS food_fiber
    FROM portions p
   CROSS JOIN default_amount da
   INNER JOIN foods f ON f.id = p.food_id
                     AND p.amount = da.value
    /* {{PORTION_FILTER}} */
),

with_target_nutrition_facts AS (
  SELECT p.id                                                             AS portion_id
       , p.amount                                                         AS portion_amount
       , p.name                                                           AS portion_name
       , p.food_id                                                        AS food_id
       , (pwf.food_kcal / pwf.default_amount) * p.amount                  AS target_portion_kcal
       , (pwf.food_carbs / pwf.default_amount) * p.amount                 AS target_portion_carbs
       , (pwf.food_carbs_sugar_part / pwf.default_amount) * p.amount      AS target_portion_carbs_sugar_part
       , (pwf.food_protein / pwf.default_amount) * p.amount               AS target_portion_protein
       , (pwf.food_fat / pwf.default_amount) * p.amount                   AS target_portion_fat
       , (pwf.food_fat_saturated / pwf.default_amount) * p.amount         AS target_portion_fat_saturated
       , (pwf.food_fiber / pwf.default_amount) * p.amount                 AS target_portion_fiber
       , p.created_at                                                     AS portion_created_at
    FROM portions p
   INNER JOIN portions_with_nutrition_facts pwf ON p.food_id = pwf.food_id
 ),

 with_rounded_target_nutrution_facts AS (
   SELECT portion_id                                         AS portion_id
        , portion_amount                                     AS portion_amount
        , portion_name                                       AS portion_name
        , food_id                                            AS food_id
        , ROUND(target_portion_kcal::NUMERIC, 0)             AS target_portion_kcal
        , ROUND(target_portion_carbs::NUMERIC, 3)            AS target_portion_carbs
        , ROUND(target_portion_carbs_sugar_part::NUMERIC, 3) AS target_portion_carbs_sugar_part
        , ROUND(target_portion_protein::NUMERIC, 3)          AS target_portion_protein
        , ROUND(target_portion_fat::NUMERIC, 3)              AS target_portion_fat
        , ROUND(target_portion_fat_saturated::NUMERIC, 3)    AS target_portion_fat_saturated
        , ROUND(target_portion_fiber::NUMERIC, 3)            AS target_portion_fiber
        , portion_created_at                                 AS portion_created_at
     FROM with_target_nutrition_facts
)
INSERT INTO portions (
    id
  , name
  , food_id
  , amount
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
SELECT portion_id
     , portion_name
     , food_id
     , portion_amount
     , target_portion_kcal
     , target_portion_carbs
     , target_portion_carbs_sugar_part
     , target_portion_protein
     , target_portion_fat
     , target_portion_fat_saturated
     , target_portion_fiber
     , portion_created_at
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
