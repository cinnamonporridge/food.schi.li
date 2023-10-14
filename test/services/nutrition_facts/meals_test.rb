require "test_helper"

class NutritionFacts::MealsTest < ActiveSupport::TestCase
  include NutritionFactsTestHelper

  test ".call! record is a Food" do
    with_snapshots(
      daisys_big_apple_meal_on_february_first: meals(:daisys_big_apple_meal_on_february_first),
      daisys_apple_pie_meal_on_february_fifth: meals(:daisys_apple_pie_meal_on_february_fifth),
      johns_apple_meal_on_january_first: meals(:johns_apple_meal_on_january_first)
    ) do |targets|
      falsify_all_nutrition_facts!
      new_object(foods(:apple)).call!

      assert_original_equals_snapshot targets[:daisys_big_apple_meal_on_february_first]
      assert_original_equals_snapshot targets[:daisys_apple_pie_meal_on_february_fifth]
      assert_original_equals_snapshot targets[:johns_apple_meal_on_january_first]
    end
  end

  test ".call! record is a Portion" do
    with_snapshots(
      daisys_big_apple_meal_on_february_first: meals(:daisys_big_apple_meal_on_february_first),
      daisys_apple_pie_meal_on_february_fifth: meals(:daisys_apple_pie_meal_on_february_fifth),
      johns_apple_meal_on_january_first: meals(:johns_apple_meal_on_january_first)
    ) do |targets|
      falsify_all_nutrition_facts!
      new_object(portions(:big_apple_portion)).call!

      assert_original_equals_snapshot targets[:daisys_big_apple_meal_on_february_first]
      assert_original_equals_snapshot targets[:daisys_apple_pie_meal_on_february_fifth]
      assert_original_equals_false targets[:johns_apple_meal_on_january_first] # uses apple_default_portion
    end
  end

  test ".call! record is a MealIngredient" do
    with_snapshots(
      daisys_big_apple_meal_on_february_first: meals(:daisys_big_apple_meal_on_february_first)
    ) do |targets|
      falsify_all_nutrition_facts!
      new_object(meal_ingredients(:daisys_big_apple_meal_ingredient_on_february_first)).call!

      assert_original_equals_snapshot targets[:daisys_big_apple_meal_on_february_first]
    end
  end

  test ".call! record is a User" do
    with_snapshots(
      daisys_big_apple_meal_on_february_first: meals(:daisys_big_apple_meal_on_february_first),
      daisys_glass_of_milk_meal_on_february_first: meals(:daisys_glass_of_milk_meal_on_february_first)
    ) do |targets|
      falsify_all_nutrition_facts!
      new_object(users(:daisy)).call!

      assert_original_equals_snapshot targets[:daisys_big_apple_meal_on_february_first]
      assert_original_equals_snapshot targets[:daisys_glass_of_milk_meal_on_february_first]
    end
  end
end
