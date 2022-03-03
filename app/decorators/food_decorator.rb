class FoodDecorator < SimpleDelegator
  include NumberHelper

  def unit_abbrevation
    Food.enum_translations(:units_abbreviations)[unit.to_sym]
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

  def data_source_url_authority
    URI.parse(data_source_url).authority
  ensure
    data_source_url
  end
end
