require "test_helper"

class Recipe::RecipeIngredientsToMealIngredientsServiceTest < ActiveSupport::TestCase
  test "copies all ingredients from a recipe to journal day" do
    recipe = recipes(:apple_pie)
    meal = journal_days(:daisy_february_first).meals.new
    servings = 5

    service = Recipe::RecipeIngredientsToMealIngredientsService.new(recipe:, meal:, servings:)

    # expected portions
    milk_portion = portions(:milk_default_portion)
    apple_portion = portions(:big_apple_portion)

    service.to_meal_ingredients.tap do |meal_ingredients|
      milk_portion_in_meal = meal_ingredients.find { it.portion == milk_portion }
      apple_portion_in_meal = meal_ingredients.find { it.portion == apple_portion }

      assert_predicate milk_portion_in_meal, :present?
      assert_predicate apple_portion_in_meal, :present?

      assert_equal "unit", milk_portion_in_meal.measure
      assert_equal "piece", apple_portion_in_meal.measure

      assert_in_delta(33.33, milk_portion_in_meal.amount.round(2).to_f)
      assert_in_delta(5.0, apple_portion_in_meal.amount.round(2).to_f)
    end
  end
end
