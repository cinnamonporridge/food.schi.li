require 'test_helper'

class NutritionFacts::RecipeIngredientsTest < ActiveSupport::TestCase
  include NutritionFactsTestHelper

  test '.call! record is a Food' do
    with_snapshots(
      apples_in_apple_pie: recipe_ingredients(:apples_in_apple_pie),
      milk_in_apple_pie: recipe_ingredients(:milk_in_apple_pie)
    ) do |targets|
      falsify_all_nutrition_facts!
      new_object(record: foods(:apple)).call!

      assert_original_equals_snapshot targets[:apples_in_apple_pie]
      assert_original_equals_false targets[:milk_in_apple_pie]
      # TODO: add a second recipe that uses same food, assert it gets calculated correctly
    end
  end

  test '.call! record is a Portion' do
    with_snapshots(
      apples_in_apple_pie: recipe_ingredients(:apples_in_apple_pie),
      milk_in_apple_pie: recipe_ingredients(:milk_in_apple_pie)
    ) do |targets|
      falsify_all_nutrition_facts!
      new_object(record: portions(:big_apple_portion)).call!

      assert_original_equals_snapshot targets[:apples_in_apple_pie]
      assert_original_equals_false targets[:milk_in_apple_pie]
      # TODO: add a second recipe that uses same port, assert it gets calculated correctly
    end
  end

  test '.call! record is a RecipeIngredient' do
    with_snapshots(
      apples_in_apple_pie: recipe_ingredients(:apples_in_apple_pie),
      milk_in_apple_pie: recipe_ingredients(:milk_in_apple_pie)
    ) do |targets|
      falsify_all_nutrition_facts!
      new_object(record: recipe_ingredients(:apples_in_apple_pie)).call!

      assert_original_equals_snapshot targets[:apples_in_apple_pie]
      assert_original_equals_false targets[:milk_in_apple_pie]
    end
  end

  test '.call! record is a Recipe' do
    with_snapshots(
      apples_in_apple_pie: recipe_ingredients(:apples_in_apple_pie),
      milk_in_apple_pie: recipe_ingredients(:milk_in_apple_pie)
    ) do |targets|
      falsify_all_nutrition_facts!
      new_object(record: recipes(:apple_pie)).call!

      assert_original_equals_snapshot targets[:apples_in_apple_pie]
      assert_original_equals_snapshot targets[:milk_in_apple_pie]
    end
  end

  test '.call! record is a User' do
    with_snapshots(
      apples_in_apple_pie: recipe_ingredients(:apples_in_apple_pie),
      milk_in_apple_pie: recipe_ingredients(:milk_in_apple_pie),
      peanut_butter_in_vegan_peanut_butter_banana: recipe_ingredients(:peanut_butter_in_vegan_peanut_butter_banana),
      apricots_in_apricot_mush: recipe_ingredients(:apricots_in_apricot_mush)
    ) do |targets|
      falsify_all_nutrition_facts!
      new_object(record: users(:daisy)).call!

      assert_original_equals_snapshot targets[:apples_in_apple_pie]
      assert_original_equals_snapshot targets[:milk_in_apple_pie]
      assert_original_equals_snapshot targets[:peanut_butter_in_vegan_peanut_butter_banana]
      assert_original_equals_false targets[:apricots_in_apricot_mush]
    end
  end
end
