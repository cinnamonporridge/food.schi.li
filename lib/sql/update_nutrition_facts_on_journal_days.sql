WITH default_amount AS (
  SELECT 100::FLOAT AS VALUE
),

with_journal_day_meal_nutrition_facts AS (
  SELECT jd.id                                      AS journal_day_id
       , (m.amount / da.value) * n.kcal             AS journal_day_meal_kcal
       , (m.amount / da.value) * n.carbs            AS journal_day_meal_carbs
       , (m.amount / da.value) * n.carbs_sugar_part AS journal_day_meal_carbs_sugar_part
       , (m.amount / da.value) * n.protein          AS journal_day_meal_protein
       , (m.amount / da.value) * n.fat              AS journal_day_meal_fat
       , (m.amount / da.value) * n.fat_saturated    AS journal_day_meal_fat_saturated
       , (m.amount / da.value) * n.fiber            AS journal_day_meal_fiber
    FROM journal_days jd
   CROSS JOIN default_amount da
   INNER JOIN meals m      ON m.journal_day_id = jd.id
   INNER JOIN portions p   ON p.id = m.portion_id
   INNER JOIN nutritions n ON n.id = p.nutrition_id
 ),
 
 with_summed_nutrition_facts AS (
   SELECT journal_day_id
        , sum(journal_day_meal_kcal)             AS journal_day_kcal_sum
        , sum(journal_day_meal_carbs)            AS journal_day_carbs_sum
        , sum(journal_day_meal_carbs_sugar_part) AS journal_day_carbs_sugar_part_sum
        , sum(journal_day_meal_protein)          AS journal_day_protein_sum
        , sum(journal_day_meal_fat)              AS journal_day_fat_sum
        , sum(journal_day_meal_fat_saturated)    AS journal_day_fat_saturated_sum
        , sum(journal_day_meal_fiber)            AS journal_day_fiber_sum
     FROM with_journal_day_meal_nutrition_facts
    GROUP BY journal_day_id
),

with_rounded_target_nutrution_facts AS (
   SELECT journal_day_id
        , ROUND(journal_day_kcal_sum::NUMERIC, 0)             AS journal_day_target_kcal
        , ROUND(journal_day_carbs_sum::NUMERIC, 3)            AS journal_day_target_carbs
        , ROUND(journal_day_carbs_sugar_part_sum::NUMERIC, 3) AS journal_day_target_carbs_sugar_part
        , ROUND(journal_day_protein_sum::NUMERIC, 3)          AS journal_day_target_protein
        , ROUND(journal_day_fat_sum::NUMERIC, 3)              AS journal_day_target_fat
        , ROUND(journal_day_fat_saturated_sum::NUMERIC, 3)    AS journal_day_target_fat_saturated
        , ROUND(journal_day_fiber_sum::NUMERIC, 3)            AS journal_day_target_fiber
    FROM with_summed_nutrition_facts
)

INSERT INTO journal_days (
    id
  , user_id
  , date
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

SELECT jd.id
     , jd.user_id
     , jd.date
     , tnf.journal_day_target_kcal
     , tnf.journal_day_target_carbs
     , tnf.journal_day_target_carbs_sugar_part
     , tnf.journal_day_target_protein
     , tnf.journal_day_target_fat
     , tnf.journal_day_target_fat_saturated
     , tnf.journal_day_target_fiber
     , jd.created_at
     , NOW() AS updated_at
  FROM with_rounded_target_nutrution_facts tnf
 INNER JOIN journal_days jd ON jd.id = tnf.journal_day_id
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
