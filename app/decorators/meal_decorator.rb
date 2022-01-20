class MealDecorator < SimpleDelegator
  def display_type
    consumable_type
  end

  def display_day_partition_name
    day_partition&.decorate&.display_name
  end

  def display_recipe_name
    consumable&.name if recipe?
  end
end
