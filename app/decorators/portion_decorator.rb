class PortionDecorator < SimpleDelegator
  include ActionView::Helpers::TagHelper

  def name_for_dropdown
    [
      name_with_food,
      "(#{amount_with_unit_abbrevation})"
    ].compact.join(' ')
  end

  def display_measure
    RecipeIngredient.human_enum_name(:measures, measure)
  end

  def amount_with_unit_abbrevation
    "#{amount}#{food.decorate.unit_abbrevation}"
  end

  def display_amount_with_unit_abbreviation_after
    tag.span(amount, class: "unit unit-#{food.decorate.unit_abbrevation}")
  end

  def name_with_food
    [
      food.name,
      name_if_not_default
    ].compact.join(' ')
  end

  def display_name
    primary? ? 'Base' : name
  end

  def self.portions_collection(user)
    portions_collection_with_id(user).map(&:first)
  end

  def self.portions_collection_with_id(user)
    PortionPolicy.scope_for_user(user, :read)
                 .ordered_by_food_name_and_amount
                 .map { |portion| [portion.decorate.name_for_dropdown, portion.id] }
  end

  private

  def name_if_not_default
    name unless primary?
  end
end
