class RecipeDecorator < Draper::Decorator
  delegate_all

  def name_with_servings
    "#{model.name} (#{model.servings} servings)"
  end

  def serving(nutrition_fact)
    (model[nutrition_fact] / model.servings).round || 0
  end

  def display_kcal
    model.kcal
  end

  def display_carbs
    model.carbs.round
  end

  def display_protein
    model.protein.round
  end

  def display_fat
    model.fat.round
  end
end
