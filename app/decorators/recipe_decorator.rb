class RecipeDecorator < SimpleDelegator
  def name_with_servings
    "#{name} (#{servings} servings)"
  end

  def serving(nutrition_fact)
    (read_attribute(nutrition_fact) / servings).round || 0
  end

  def display_kcal
    kcal
  end

  def display_carbs
    carbs.round
  end

  def display_protein
    protein.round
  end

  def display_fat
    fat.round
  end
end
