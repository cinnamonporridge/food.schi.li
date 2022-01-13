class FoodDecorator < SimpleDelegator
  def unit_abbrevation
    {
      gram: 'g',
      mililiter: 'ml'
    }[unit.to_sym]
  end

  def units_collection
    Food.units.map { |name, _v| [name.capitalize, name] }
  end

  def food_collection
    Food.ordered_by_name.map { |food| [food.name, food.id] }
  end
end
