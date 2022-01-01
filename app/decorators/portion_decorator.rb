class PortionDecorator < SimpleDelegator
  def name_for_dropdown
    [
      name_with_nutrition,
      "(#{amount_with_unit_abbrevation})"
    ].compact.join(' ')
  end

  def name_if_not_default
    name unless primary?
  end

  def amount_with_unit_abbrevation
    "#{amount}#{nutrition.decorate.unit_abbrevation}"
  end

  def name_with_nutrition
    [
      nutrition.name,
      name_if_not_default
    ].compact.join(' ')
  end

  def self.portions_collection
    portions_collection_with_id.map(&:first)
  end

  def self.portions_collection_with_id
    Portion.ordered_by_nutrition_name_and_amount.map { |portion| [portion.decorate.name_for_dropdown, portion.id] }
  end
end
