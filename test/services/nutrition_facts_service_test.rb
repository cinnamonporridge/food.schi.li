require 'test_helper'

class NutritionFactsServiceTest < ActiveSupport::TestCase
  test '#promote_to_portions' do
    banana_default = portions(:banana_default_portion)
    banana_regular = portions(:regular_banana_portion)

    NutritionFactsService.new.promote_to_portions

    banana_default.reload
    banana_regular.reload

    assert_equal 90, banana_default.kcal

    assert_equal 104, banana_regular.kcal
    assert_equal 104.4, banana_regular.carbs
    assert_equal 10.44, banana_regular.carbs_sugar_part
    assert_equal 104.4, banana_regular.protein
    assert_equal 104.4, banana_regular.fat
    assert_equal 10.44, banana_regular.fat_saturated
    assert_equal 104.4, banana_regular.fiber
  end

  test '#promote_to_ingredients' do
    peanut_butter = ingredients(:peanut_butter_in_vegan_peanut_butter_banana)
    banana = ingredients(:banana_in_vegan_peanut_butter_banana)

    NutritionFactsService.new.promote_to_ingredients

    peanut_butter.reload
    banana.reload

    assert_equal 400, peanut_butter.kcal
    assert_equal 399.6, peanut_butter.carbs
    assert_equal 39.6, peanut_butter.carbs_sugar_part
    assert_equal 399.6, peanut_butter.protein
    assert_equal 399.6, peanut_butter.fat
    assert_equal 39.6, peanut_butter.fat_saturated
    assert_equal 399.6, peanut_butter.fiber

    assert_equal 1, banana.kcal
    assert_equal 0.9, banana.carbs
    assert_equal 0.09, banana.carbs_sugar_part
    assert_equal 0.9, banana.protein
    assert_equal 0.9, banana.fat
    assert_equal 0.09, banana.fat_saturated
    assert_equal 0.9, banana.fiber
  end

  test '#promote_to_recipes' do
    recipe = recipes(:apple_pie)

    NutritionFactsService.new.promote_to_recipes

    recipe.reload

    assert_equal 54, recipe.kcal
    assert_equal 54, recipe.carbs
    assert_equal 5.4, recipe.carbs_sugar_part
    assert_equal 54, recipe.protein
    assert_equal 54, recipe.fat
    assert_equal 5.4, recipe.fat_saturated
    assert_equal 54, recipe.fiber
  end
end
