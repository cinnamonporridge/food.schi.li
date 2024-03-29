class NutritionFacts::Portions < NutritionFacts::Base
  private

  def model_to_column_filter_mapping
    {
      Food: "f.id",
      Portion: "p.id",
      User: "f.user_id"
    }
  end

  def update_sql
    <<~SQL.squish
      WITH target AS (
      SELECT p.id
           , ROUND(((f.kcal::NUMERIC             / d.default_amount) * p.amount), 0) AS kcal
           , ROUND(((f.carbs::NUMERIC            / d.default_amount) * p.amount), 3) AS carbs
           , ROUND(((f.carbs_sugar_part::NUMERIC / d.default_amount) * p.amount), 3) AS carbs_sugar_part
           , ROUND(((f.protein::NUMERIC          / d.default_amount) * p.amount), 3) AS protein
           , ROUND(((f.fat::NUMERIC              / d.default_amount) * p.amount), 3) AS fat
           , ROUND(((f.fat_saturated::NUMERIC    / d.default_amount) * p.amount), 3) AS fat_saturated
           , ROUND(((f.fiber::NUMERIC            / d.default_amount) * p.amount), 3) AS fiber
        FROM portions p
       CROSS JOIN (SELECT 100 AS default_amount) AS d
       INNER JOIN foods f ON f.id = p.food_id
       WHERE 0 = 0
         AND #{filter}
      )
      UPDATE portions p
         SET kcal             = target.kcal
           , carbs            = target.carbs
           , carbs_sugar_part = target.carbs_sugar_part
           , protein          = target.protein
           , fat              = target.fat
           , fat_saturated    = target.fat_saturated
           , fiber            = target.fiber
        FROM target
       WHERE p.id = target.id
    SQL
  end
end
