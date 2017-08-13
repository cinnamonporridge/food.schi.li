class RecipeDecorator < Draper::Decorator
  delegate_all

  # SUMS
  def sum_kcal
    model.sum_kcal.round || 0
  end

  def sum_carbs
    model.sum_carbs.round || 0
  end

  def sum_carbs_sugar_part
    model.sum_carbs_sugar_part.round || 0
  end

  def sum_protein
    model.sum_protein.round || 0
  end

  def sum_fat
    model.sum_fat.round || 0
  end

  def sum_fat_saturated
    model.sum_fat_saturated.round || 0
  end

  def sum_fiber
    model.sum_fiber.round || 0
  end

  # SERVINGS
  def serving_kcal
    model.serving_kcal.round || 0
  end

  def serving_carbs
    model.serving_carbs.round || 0
  end

  def serving_carbs_sugar_part
    model.serving_carbs_sugar_part.round || 0
  end

  def serving_protein
    model.serving_protein.round || 0
  end

  def serving_fat
    model.serving_fat.round || 0
  end

  def serving_fat_saturated
    model.serving_fat_saturated.round || 0
  end

  def serving_fiber
    model.serving_fiber.round || 0
  end

  def missing_portion_collection
    Portion.without(model.portions).ordered_by_nutrition_name_and_amount.map do |portion|
      [portion.decorate.name_for_dropdown, portion.id]
    end
  end
end
