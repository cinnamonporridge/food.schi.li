require 'test_helper'

class VeganDetection::JournalDayTest < ActiveSupport::TestCase
  setup do
    @journal_day = journal_days(:daisy_february_fifth) # contains milk from apple pie
  end

  test 'updates non-vegan journal day' do
    @journal_day.update(vegan: true)

    assert_changes -> { @journal_day.vegan }, to: false do
      VeganDetection::JournalDay.new(@journal_day).call!
      @journal_day.reload
    end
  end

  test 'updates vegan journal day, all meals are vegan' do
    @journal_day.update(vegan: false)
    meal_ingredients(:daisys_milk_from_apple_pie_meal_ingredient_on_february_fifth).destroy!

    assert_changes -> { @journal_day.vegan }, to: true do
      VeganDetection::JournalDay.new(@journal_day).call!
      @journal_day.reload
    end
  end

  test 'updates vegan journal day, no meals' do
    @journal_day.update(vegan: false)
    @journal_day.meals.destroy_all

    assert_changes -> { @journal_day.vegan }, to: true do
      VeganDetection::JournalDay.new(@journal_day).call!
      @journal_day.reload
    end
  end

  test 'journal day changes to vegan if food changes to vegan' do
    @journal_day.update(vegan: false)
    food = foods(:milk)
    food.update(vegan: true)

    assert_changes -> { @journal_day.vegan }, to: true do
      VeganDetection::JournalDay.new(food).call!
      @journal_day.reload
    end
  end
end
