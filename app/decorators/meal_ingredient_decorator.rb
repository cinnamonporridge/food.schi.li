class MealIngredientDecorator < SimpleDelegator
  include ActionView::Helpers::TagHelper

  def quantity
    return if measure_unit?

    (amount / portion.amount).round(2)
  end

  def quantity_with_pieces
    return if measure_unit?

    "(#{quantity} #{I18n.t('shared.quantity_pieces_abbreviation', count: quantity)})"
  end

  def unit_abbrevation
    portion.food.decorate.unit_abbrevation
  end

  def rounded_amount_with_unit_abbrevation
    tag.data amount.round.to_s, class: "unit unit-#{unit_abbrevation}"
  end

  def display_portion_name
    portion.decorate.name_with_food
  end
end
