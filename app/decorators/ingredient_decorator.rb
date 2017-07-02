class IngredientDecorator < Draper::Decorator
  def quantity
    return if model.portion.primary?
    (model.amount / model.portion.amount).round
  end

  def rounded_amount
    model.amount.round
  end

  def unit_abbrevation
    model.nutrition.decorate.unit_abbrevation
  end
end
