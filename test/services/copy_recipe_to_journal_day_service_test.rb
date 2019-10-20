require 'test_helper'

class CopyRecipeToJournalDayServiceTest < ActiveSupport::TestCase
  test 'copies all ingredients from a recipe to journal day' do
    recipe = recipes(:apple_pie)
    number_of_servings = 5
    journal_day = journal_days(:daisy_february_second)

    assert_difference 'journal_day.meals.count', 2 do
      CopyRecipeToJournalDayService.new(recipe, number_of_servings, journal_day).call
    end

    # expected portions
    milk_portion = portions(:milk_default_portion)
    apple_portion = portions(:big_apple_portion)

    journal_day.meals.reload

    milk_portion_on_journal_day = journal_day.meals.find_by(portion: milk_portion)
    apple_portion_on_journal_day = journal_day.meals.find_by(portion: apple_portion)

    assert milk_portion_on_journal_day.present?
    assert apple_portion_on_journal_day.present?

    assert_equal recipe, milk_portion_on_journal_day.recipe, 'Milk should come from the apple pie recipe'
    assert_equal recipe, apple_portion_on_journal_day.recipe, 'Apple should come from the apple pie recipe'

    assert_equal 'unit', milk_portion_on_journal_day.measure
    assert_equal 'piece', apple_portion_on_journal_day.measure

    assert_equal 33.33, milk_portion_on_journal_day.amount.round(2).to_f
    assert_equal 5.0, apple_portion_on_journal_day.amount.round(2).to_f
  end
end
