class IngredientDecorator < Draper::Decorator
  def quantity
    return if model.measure_unit?
    (model.amount / model.portion.amount).round(2)
  end

  def rounded_amount
    model.amount.round
  end

  def unit_abbrevation
    model.nutrition.decorate.unit_abbrevation
  end
end
