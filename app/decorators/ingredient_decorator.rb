class IngredientDecorator < Draper::Decorator
  def quantity
    return if model.portion.primary?
    model.amount / model.portion.amount
  end

  def amount_with_unit_abbrevation
    "#{model.amount}#{model.nutrition.decorate.unit_abbrevation}"
  end
end
