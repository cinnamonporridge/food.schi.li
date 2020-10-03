class RecipeDecorator < Draper::Decorator
  delegate_all

  def name_with_servings
    "#{model.name} (#{model.servings} servings)"
  end

  def serving(nutrition_fact)
    (model[nutrition_fact] / model.servings).round || 0
  end
end
