WITH default_amount AS (
  SELECT 100::FLOAT AS VALUE
)

, with_journal_day_meal_nutrition_facts AS (
  SELECT jd.id                                       AS journal_day_id
       , (mi.amount / da.value) * f.kcal             AS journal_day_meal_kcal
       , (mi.amount / da.value) * f.carbs            AS journal_day_meal_carbs
       , (mi.amount / da.value) * f.carbs_sugar_part AS journal_day_meal_carbs_sugar_part
       , (mi.amount / da.value) * f.protein          AS journal_day_meal_protein
       , (mi.amount / da.value) * f.fat              AS journal_day_meal_fat
       , (mi.amount / da.value) * f.fat_saturated    AS journal_day_meal_fat_saturated
       , (mi.amount / da.value) * f.fiber            AS journal_day_meal_fiber
    FROM journal_days jd
   CROSS JOIN default_amount da
   LEFT OUTER JOIN meals m                  ON m.journal_day_id = jd.id
   LEFT OUTER JOIN meal_ingredients mi      ON mi.meal_id = m.id
   LEFT OUTER JOIN portions p               ON p.id = mi.portion_id
   LEFT OUTER JOIN foods f                  ON f.id = p.food_id
)

, with_summed_nutrition_facts AS (
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
)

, with_rounded_target_nutrution_facts AS (
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
     , COALESCE(tnf.journal_day_target_kcal, 0)             AS journal_day_target_kcal
     , COALESCE(tnf.journal_day_target_carbs, 0)            AS journal_day_target_carbs
     , COALESCE(tnf.journal_day_target_carbs_sugar_part, 0) AS journal_day_target_carbs_sugar_part
     , COALESCE(tnf.journal_day_target_protein, 0)          AS journal_day_target_protein
     , COALESCE(tnf.journal_day_target_fat, 0)              AS journal_day_target_fat
     , COALESCE(tnf.journal_day_target_fat_saturated, 0)    AS journal_day_target_fat_saturated
     , COALESCE(tnf.journal_day_target_fiber, 0)            AS journal_day_target_fiber
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
