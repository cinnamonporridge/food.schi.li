class NutritionFacts::JournalDays < NutritionFacts::Base
  private

  def model_to_column_filter_mapping
    {
      Food: 'f.id',
      Portion: 'p.id',
      MealIngredient: 'mi.id',
      Meal: 'm.id',
      JournalDay: 'jd.id',
      User: 'jd.user_id'
    }
  end

  def update_sql
    <<~SQL.squish
      WITH journal_days_scope AS (
        SELECT jd.id      AS journal_day_id
          FROM journal_days jd
          LEFT OUTER JOIN meals m                  ON m.journal_day_id = jd.id
          LEFT OUTER JOIN meal_ingredients mi      ON mi.meal_id = m.id
          LEFT OUTER JOIN portions p               ON p.id = mi.portion_id
          LEFT OUTER JOIN foods f                  ON f.id = p.food_id
        WHERE #{filter}
      )
      , with_journal_day_meal_nutrition_facts AS (
        SELECT jd.id                                               AS journal_day_id
             , (mi.amount / d.default_amount) * f.kcal             AS kcal
             , (mi.amount / d.default_amount) * f.carbs            AS carbs
             , (mi.amount / d.default_amount) * f.carbs_sugar_part AS carbs_sugar_part
             , (mi.amount / d.default_amount) * f.protein          AS protein
             , (mi.amount / d.default_amount) * f.fat              AS fat
             , (mi.amount / d.default_amount) * f.fat_saturated    AS fat_saturated
             , (mi.amount / d.default_amount) * f.fiber            AS fiber
          FROM journal_days jd
         CROSS JOIN (SELECT 100 AS default_amount) AS d
          LEFT OUTER JOIN meals m                  ON m.journal_day_id = jd.id
          LEFT OUTER JOIN meal_ingredients mi      ON mi.meal_id = m.id
          LEFT OUTER JOIN portions p               ON p.id = mi.portion_id
          LEFT OUTER JOIN foods f                  ON f.id = p.food_id
         WHERE jd.id IN (SELECT journal_day_id FROM journal_days_scope)
      )
      , with_summed_nutrition_facts AS (
         SELECT journal_day_id
              , COALESCE(ROUND(sum(kcal)            , 0), 0) AS kcal
              , COALESCE(ROUND(sum(carbs)           , 3), 0) AS carbs
              , COALESCE(ROUND(sum(carbs_sugar_part), 3), 0) AS carbs_sugar_part
              , COALESCE(ROUND(sum(protein)         , 3), 0) AS protein
              , COALESCE(ROUND(sum(fat)             , 3), 0) AS fat
              , COALESCE(ROUND(sum(fat_saturated)   , 3), 0) AS fat_saturated
              , COALESCE(ROUND(sum(fiber)           , 3), 0) AS fiber
           FROM with_journal_day_meal_nutrition_facts
          GROUP BY journal_day_id
      )
      UPDATE journal_days jd
         SET kcal             = target.kcal
           , carbs            = target.carbs
           , carbs_sugar_part = target.carbs_sugar_part
           , protein          = target.protein
           , fat              = target.fat
           , fat_saturated    = target.fat_saturated
           , fiber            = target.fiber
        FROM with_summed_nutrition_facts target
       WHERE jd.id = target.journal_day_id
    SQL
  end
end
