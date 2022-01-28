class JournalDay::NutritionsTableComponent < ViewComponent::Base
  attr_reader :journal_day

  delegate :format_nutrition_number, to: :helpers

  def initialize(journal_day:)
    @journal_day = journal_day
    super()
  end

  def ordered_meals
    @ordered_meals ||= journal_day.meals.ordered_by_consumable_type_and_day_partition
  end

  def meal_component(meal)
    return JournalDay::NutritionsTable::RecipeMealComponent.new(meal:) if meal.recipe?
    return JournalDay::NutritionsTable::PortionMealComponent.new(meal:) if meal.portion?
  end
end
