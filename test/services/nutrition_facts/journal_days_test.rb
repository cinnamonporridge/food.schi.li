require "test_helper"

class NutritionFacts::JournalDaysTest < ActiveSupport::TestCase
  include NutritionFactsTestHelper

  test ".call! record is a Food" do
    with_snapshots(
      john_january_first: journal_days(:john_january_first),
      daisy_february_first: journal_days(:daisy_february_first)
    ) do |targets|
      falsify_all_nutrition_facts!
      new_object(foods(:apple)).call!

      assert_original_equals_snapshot targets[:john_january_first]
      assert_original_equals_snapshot targets[:daisy_february_first]
    end
  end

  test ".call! record is a Portion" do
    with_snapshots(
      john_january_first: journal_days(:john_january_first),
      daisy_february_first: journal_days(:daisy_february_first)
    ) do |targets|
      falsify_all_nutrition_facts!
      new_object(portions(:big_apple_portion)).call!

      assert_original_equals_false targets[:john_january_first]
      assert_original_equals_snapshot targets[:daisy_february_first]
    end
  end

  test ".call! record is a MealIngredient" do
    with_snapshots(daisy_february_first: journal_days(:daisy_february_first)) do |targets|
      falsify_all_nutrition_facts!
      new_object(meal_ingredients(:daisys_big_apple_meal_ingredient_on_february_first)).call!

      assert_original_equals_snapshot targets[:daisy_february_first]
    end
  end

  test ".call! record is a User" do
    with_snapshots(
      john_january_first: journal_days(:john_january_first),
      daisy_february_first: journal_days(:daisy_february_first)
    ) do |targets|
      falsify_all_nutrition_facts!
      new_object(users(:daisy)).call!

      assert_original_equals_false targets[:john_january_first]
      assert_original_equals_snapshot targets[:daisy_february_first]
    end
  end
end
