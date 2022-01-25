UPDATE ingredients i
   SET kcal             = target.kcal
     , carbs            = target.carbs
     , carbs_sugar_part = target.carbs_sugar_part
     , protein          = target.protein
     , fat              = target.fat
     , fat_saturated    = target.fat_saturated
     , fiber            = target.fiber
  FROM (  SELECT i.id
               , ROUND(((i.amount / d.default_amount) * f.kcal)             , 0) AS kcal
               , ROUND(((i.amount / d.default_amount) * f.carbs)            , 3) AS carbs
               , ROUND(((i.amount / d.default_amount) * f.carbs_sugar_part) , 3) AS carbs_sugar_part
               , ROUND(((i.amount / d.default_amount) * f.protein)          , 3) AS protein
               , ROUND(((i.amount / d.default_amount) * f.fat)              , 3) AS fat
               , ROUND(((i.amount / d.default_amount) * f.fat_saturated)    , 3) AS fat_saturated
               , ROUND(((i.amount / d.default_amount) * f.fiber)            , 3) AS fiber
            FROM ingredients i
           CROSS JOIN (SELECT 100 AS default_amount) AS d
           INNER JOIN portions p ON p.id = i.portion_id
           INNER JOIN foods f    ON f.id = p.food_id
        ) target
 WHERE i.id = target.id
;
