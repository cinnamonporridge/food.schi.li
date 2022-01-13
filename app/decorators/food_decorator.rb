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
end
