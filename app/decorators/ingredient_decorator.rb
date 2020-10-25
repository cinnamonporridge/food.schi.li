class IngredientDecorator < Draper::Decorator
  delegate_all

  def quantity
    return if model.measure_unit?

    (model.amount / model.portion.amount).round(2)
  end

  def quantity_with_pieces
    return if model.measure_unit?

    "(#{quantity} #{'pc'.pluralize(quantity)})"
  end

  def rounded_amount
    model.amount.round
  end

  def unit_abbrevation
    model.nutrition.decorate.unit_abbrevation
  end

  def rounded_amount_with_unit_abbrevation
    h.tag.data model.amount.round.to_s, class: "unit unit-#{unit_abbrevation}"
  end

  def display_kcal
    model.kcal
  end

  def display_carbs
    model.carbs.round
  end

  def display_protein
    model.protein.round
  end

  def display_fat
    model.fat.round
  end
end
