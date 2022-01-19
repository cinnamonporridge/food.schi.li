require 'test_helper'

class CopyRecipeToJournalDayServiceTest < ActiveSupport::TestCase
  test 'copies all ingredients from a recipe to journal day' do
    recipe = recipes(:apple_pie)
    number_of_servings = 5
    journal_day = journal_days(:daisy_february_second)

    assert_difference -> { journal_day.meals.count }, +1 do
      CopyRecipeToJournalDayService.new(recipe, number_of_servings, journal_day).call
    end

    # expected portions
    milk_portion = portions(:milk_default_portion)
    apple_portion = portions(:big_apple_portion)

    journal_day.meals.last.tap do |meal|
      assert_equal recipe, meal.consumable

      milk_portion_in_meal = meal.meal_ingredients.find_by(portion: milk_portion)
      apple_portion_in_meal = meal.meal_ingredients.find_by(portion: apple_portion)

      assert milk_portion_in_meal.present?
      assert apple_portion_in_meal.present?

      assert_equal 'unit', milk_portion_in_meal.measure
      assert_equal 'piece', apple_portion_in_meal.measure

      assert_in_delta(33.33, milk_portion_in_meal.amount.round(2).to_f)
      assert_in_delta(5.0, apple_portion_in_meal.amount.round(2).to_f)
    end
  end
end
