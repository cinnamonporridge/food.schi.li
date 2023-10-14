require "test_helper"

class NutritionFacts::RecipesTest < ActiveSupport::TestCase
  include NutritionFactsTestHelper

  test ".call! record is a Food" do
    with_snapshots(apple_pie: recipes(:apple_pie)) do |targets|
      falsify_all_nutrition_facts!
      new_object(foods(:apple)).call!

      assert_original_equals_snapshot targets[:apple_pie]
      # TODO: add a second recipe that uses same food, assert it gets calculated correctly
    end
  end

  test ".call! record is a Portion" do
    with_snapshots(apple_pie: recipes(:apple_pie)) do |targets|
      falsify_all_nutrition_facts!
      new_object(portions(:big_apple_portion)).call!

      assert_original_equals_snapshot targets[:apple_pie]
      # TODO: add a second recipe that uses same portion, assert it gets calculated correctly
    end
  end

  test ".call! record is a RecipeIngredient" do
    with_snapshots(apple_pie: recipes(:apple_pie)) do |targets|
      falsify_all_nutrition_facts!
      new_object(recipe_ingredients(:apples_in_apple_pie)).call!

      assert_original_equals_snapshot targets[:apple_pie]
    end
  end

  test ".call! record is a User" do
    with_snapshots(
      apple_pie: recipes(:apple_pie),
      anchovy_soup: recipes(:anchovy_soup),
      apricot_mush: recipes(:apricot_mush)
    ) do |targets|
      falsify_all_nutrition_facts!
      new_object(users(:daisy)).call!

      assert_original_equals_snapshot targets[:apple_pie]
      assert_original_equals_snapshot targets[:anchovy_soup]
      assert_original_equals_false targets[:apricot_mush]
    end
  end
end
