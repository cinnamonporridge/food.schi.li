class JournalDay::NutritionsTable::RecipeMealComponent < ViewComponent::Base
  attr_reader :meal

  delegate :format_nutrition_number, to: :helpers

  def initialize(meal:)
    @meal = meal
    super()
  end
end
