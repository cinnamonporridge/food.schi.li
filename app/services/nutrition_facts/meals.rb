class NutritionFacts::Meals < NutritionFacts::Base
  private

  def update_sql
    <<~SQL.squish
      UPDATE meals
         SET kcal              = target.kcal_sum
           , carbs             = target.carbs_sum
           , carbs_sugar_part  = target.carbs_sugar_part_sum
           , protein           = target.protein_sum
           , fat               = target.fat_sum
           , fat_saturated     = target.fat_saturated_sum
           , fiber             = target.fiber_sum
        FROM ( SELECT meal_id
                    , sum(kcal)              AS kcal_sum
                    , sum(carbs)             AS carbs_sum
                    , sum(carbs_sugar_part)  AS carbs_sugar_part_sum
                    , sum(protein)           AS protein_sum
                    , sum(fat)               AS fat_sum
                    , sum(fat_saturated)     AS fat_saturated_sum
                    , sum(fiber)             AS fiber_sum
                 FROM meal_ingredients
             GROUP BY meal_id ) AS target
       WHERE meals.id = target.meal_id
    SQL
  end
end
