class NutritionDecorator < Draper::Decorator
  delegate_all

  def unit_abbrevation
    {
      gram: 'g',
      mililiter: 'ml'
    }[unit.to_sym]
  end

  def units_collection
    Nutrition.units.map { |name,_v|  [name.capitalize, name] }
  end

  def nutrition_collection
    Nutrition.ordered_by_name.map { |nutrition| [nutrition.name, nutrition.id] }
  end

  def recipes_using
    Recipe.using(model)
  end
end
