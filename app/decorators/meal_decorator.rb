class MealDecorator < SimpleDelegator
  include ActionView::Helpers::TagHelper

  def quantity
    return if measure_unit?

    (amount / portion.amount).round(2)
  end

  def quantity_with_pieces
    return if measure_unit?

    "(#{quantity} #{'pc'.pluralize(quantity)})"
  end

  def unit_abbrevation
    portion.nutrition.decorate.unit_abbrevation
  end

  def rounded_amount_with_unit_abbrevation
    tag.data amount.round.to_s, class: "unit unit-#{unit_abbrevation}"
  end

  def display_total_kcal
    total_kcal.round
  end

  def display_total_carbs
    total_carbs.round
  end

  def display_total_carbs_sugar_part
    total_carbs_sugar_part.round
  end

  def display_total_protein
    total_protein.round
  end

  def display_total_fat
    total_fat.round
  end

  def display_total_fat_saturated
    total_fat_saturated.round
  end

  def display_total_fiber
    total_fiber.round
  end
end
