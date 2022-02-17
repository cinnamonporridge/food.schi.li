require 'test_helper'

class NutritionFacts::MealIngredientsTest < ActiveSupport::TestCase
  include NutritionFactsTestHelper

  test '.call! record is a Food' do
    with_snapshots(
      daisys_apple_on_february_first: meal_ingredients(:daisys_big_apple_meal_ingredient_on_february_first),
      johns_apple_on_january_first: meal_ingredients(:johns_apple_on_january_first)
    ) do |targets|
      falsify_all_nutrition_facts!
      new_object(foods(:apple)).call!

      assert_original_equals_snapshot targets[:daisys_apple_on_february_first]
      assert_original_equals_snapshot targets[:johns_apple_on_january_first]
    end
  end

  test '.call! record is a Portion' do
    with_snapshots(
      milk_on_february_first: meal_ingredients(:daisys_glass_of_milk_meal_ingredient_on_february_first),
      milk_on_february_fifth: meal_ingredients(:daisys_milk_from_apple_pie_meal_ingredient_on_february_fifth)
    ) do |targets|
      falsify_all_nutrition_facts!
      new_object(portions(:milk_default_portion)).call!

      assert_original_equals_snapshot targets[:milk_on_february_first]
      assert_original_equals_snapshot targets[:milk_on_february_fifth]
    end
  end

  test '.call! record is a MealIngredient' do
    with_snapshots(
      milk_on_february_first: meal_ingredients(:daisys_glass_of_milk_meal_ingredient_on_february_first),
      milk_on_february_fifth: meal_ingredients(:daisys_milk_from_apple_pie_meal_ingredient_on_february_fifth)
    ) do |targets|
      falsify_all_nutrition_facts!
      new_object(meal_ingredients(:daisys_glass_of_milk_meal_ingredient_on_february_first)).call!

      assert_original_equals_snapshot targets[:milk_on_february_first]
      assert_original_equals_false targets[:milk_on_february_fifth]
    end
  end

  test '.call! record is a User' do
    with_snapshots(
      daisys_apples_on_february_first: meal_ingredients(:daisys_big_apple_meal_ingredient_on_february_first),
      johns_apple_on_january_first: meal_ingredients(:johns_apple_on_january_first)
    ) do |targets|
      falsify_all_nutrition_facts!
      new_object(users(:daisy)).call!

      assert_original_equals_snapshot targets[:daisys_apples_on_february_first]
      assert_original_equals_false targets[:johns_apple_on_january_first]
    end
  end
end
