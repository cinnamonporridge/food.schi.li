class FoodDecorator < SimpleDelegator
  include NumberHelper

  def unit_abbrevation
    {
      gram: 'g',
      mililiter: 'ml'
    }[unit.to_sym]
  end

  def units_collection
    Food.units.map { |name, _v| [name.capitalize, name] }
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
end
