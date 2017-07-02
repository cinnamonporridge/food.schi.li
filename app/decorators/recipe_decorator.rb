class RecipeDecorator < Draper::Decorator

  # SUMS
  def sum_kcal
    model.sum_kcal || 0.0
  end

  def sum_carbs
    model.sum_carbs || 0.0
  end

  def sum_carbs_sugar_part
    model.sum_carbs_sugar_part || 0.0
  end

  def sum_protein
    model.sum_protein || 0.0
  end

  def sum_fat
    model.sum_fat || 0.0
  end

  def sum_fat_saturated
    model.sum_fat_saturated || 0.0
  end

  def sum_fiber
    model.sum_fiber || 0.0
  end

  # SERVINGS
  def serving_kcal
    (model.serving_kcal || 0.0).round(1)
  end

  def serving_carbs
    (model.serving_carbs || 0.0).round(1)
  end

  def serving_carbs_sugar_part
    (model.serving_carbs_sugar_part || 0.0).round(1)
  end

  def serving_protein
    (model.serving_protein || 0.0).round(1)
  end

  def serving_fat
    (model.serving_fat || 0.0).round(1)
  end

  def serving_fat_saturated
    (model.serving_fat_saturated || 0.0).round(1)
  end

  def serving_fiber
    (model.serving_fiber || 0.0).round(1)
  end

  # PERCENTAGES
  def macro_nutritient_carbs_percentage
    return "0%" unless model.macro_nutritient_total > 0.0
    "#{((model.sum_carbs / model.macro_nutritient_total) * 100).round}%"
  end

  def macro_nutritient_protein_percentage
    return "0%" unless model.macro_nutritient_total > 0.0
    "#{((model.sum_protein / model.macro_nutritient_total) * 100).round}%"
  end

  def macro_nutritient_fat_percentage
    return "0%" unless model.macro_nutritient_total > 0.0
    "#{((model.sum_fat / model.macro_nutritient_total) * 100).round}%"
  end

  def missing_portion_collection
    Portion.without(model.portions).ordered_by_nutrition_name_and_amount.map do |portion|
      [portion.decorate.name_for_dropdown, portion.id]
    end
  end

  def macronutrients_chart_data
    {
      'Carbs': (model.sum_carbs / model.macro_nutritient_total),
      'Protein': (model.sum_protein / model.macro_nutritient_total),
      'Fat': (model.sum_fat / model.macro_nutritient_total)
    }
  end
end
