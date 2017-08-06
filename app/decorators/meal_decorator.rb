class MealDecorator < Draper::Decorator
  def quantity
    return if model.measure_unit?
    (model.amount / model.portion.amount).round(2)
  end

  def quantity_with_pieces
    return if model.measure_unit?
    "(#{quantity} #{'pc'.pluralize(quantity)})"
  end

  def unit_abbrevation
    model.portion.nutrition.decorate.unit_abbrevation
  end
  def rounded_amount_with_unit_abbrevation
    "#{model.amount.round}#{unit_abbrevation}"
  end
end
