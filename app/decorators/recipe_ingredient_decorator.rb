class RecipeIngredientDecorator < SimpleDelegator
  include ActionView::Helpers::TagHelper
  include NumberHelper

  def quantity
    return if measure_unit?

    (amount / portion.amount).round(2)
  end

  def quantity_with_pieces
    return if measure_unit?

    "(#{quantity} #{I18n.t('shared.quantity_pieces_abbreviation', count: quantity)})"
  end

  def rounded_amount
    amount.round
  end

  def unit_abbrevation
    food.decorate.unit_abbrevation
  end

  def rounded_amount_with_unit_abbrevation
    tag.data amount.round.to_s, class: "unit unit-#{unit_abbrevation}"
  end

  def display_kcal
    format_nutrition_number(kcal)
  end

  def display_carbs
    format_nutrition_number(carbs)
  end

  def display_protein
    format_nutrition_number(protein.round)
  end

  def display_fat
    format_nutrition_number(fat)
  end

  def self.measures_collection
    RecipeIngredient.enum_translations(:measures).stringify_keys.map(&:reverse).reverse
  end
end
