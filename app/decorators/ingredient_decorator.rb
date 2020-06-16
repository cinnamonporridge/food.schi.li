class IngredientDecorator < Draper::Decorator
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
    h.tag :data, class: "unit unit-#{unit_abbrevation}" do
      model.amount.round.to_s
    end
  end

  def total_kcal
    model.total_kcal.round
  end

  def total_carbs
    model.total_carbs.round
  end

  def total_carbs_sugar_part
    model.total_carbs_sugar_part.round
  end

  def total_protein
    model.total_protein.round
  end

  def total_fat
    model.total_fat.round
  end

  def total_fat_saturated
    model.total_fat_saturated.round
  end

  def total_fiber
    model.total_fiber.round
  end
end
