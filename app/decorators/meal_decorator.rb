class MealDecorator < SimpleDelegator
  def display_day_partition_name
    day_partition.decorate.display_name
  end

  def display_name
    return display_recipe_name if recipe?

    display_portion_name if portion?
  end

  def display_recipe_name
    consumable&.name if recipe?
  end

  def display_portion_name
    consumable&.decorate&.name_with_food if portion?
  end
end
