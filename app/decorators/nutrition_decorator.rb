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
end
