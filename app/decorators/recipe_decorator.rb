class RecipeDecorator < SimpleDelegator
  include NumberHelper

  def name_with_servings
    "#{name} (#{I18n.t('recipe.servings_with_count', count: servings)})"
  end

  def display_kcal
    format_nutrition_number(kcal)
  end

  def display_carbs
    format_nutrition_number(carbs)
  end

  def display_protein
    format_nutrition_number(protein)
  end

  def display_fat
    format_nutrition_number(fat)
  end

  def display_kcal_per_serving
    format_nutrition_number(per_serving(:kcal))
  end

  def display_carbs_per_serving
    format_nutrition_number(per_serving(:carbs))
  end

  def display_protein_per_serving
    format_nutrition_number(per_serving(:protein))
  end

  def display_fat_per_serving
    format_nutrition_number(per_serving(:fat))
  end

  private

  def per_serving(nutrition)
    (read_attribute(nutrition) / servings.to_f)
  end
end
