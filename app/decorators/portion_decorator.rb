class PortionDecorator < Draper::Decorator
  def name_for_dropdown
    [
      name_with_nutrition,
      "(#{amount_with_unit_abbrevation})"
    ].compact.join(' ')
  end

  def name_if_not_default
    model.name unless model.primary?
  end

  def amount_with_unit_abbrevation
    "#{model.amount}#{model.nutrition.decorate.unit_abbrevation}"
  end

  def name_with_nutrition
    [
      model.nutrition.name,
      name_if_not_default
    ].compact.join(' ')
  end
end
