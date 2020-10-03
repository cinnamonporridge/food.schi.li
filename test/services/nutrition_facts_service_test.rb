require 'test_helper'

class NutritionFactsServiceTest < ActiveSupport::TestCase
  test '.update(:portions)' do
    banana_default = portions(:banana_default_portion)
    banana_regular = portions(:regular_banana_portion)

    NutritionFactsService.update(:portions)

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

  test '.update(:ingredients)' do
    peanut_butter = ingredients(:peanut_butter_in_vegan_peanut_butter_banana)
    banana = ingredients(:banana_in_vegan_peanut_butter_banana)

    NutritionFactsService.update(:ingredients)

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

  test '.update(:recipes)' do
    recipe = recipes(:apple_pie)

    NutritionFactsService.update(:recipes)

    recipe.reload

    assert_equal 54, recipe.kcal
    assert_equal 54, recipe.carbs
    assert_equal 5.4, recipe.carbs_sugar_part
    assert_equal 54, recipe.protein
    assert_equal 54, recipe.fat
    assert_equal 5.4, recipe.fat_saturated
    assert_equal 54, recipe.fiber
  end

  test '.update(:meals)' do
    meal = meals(:johns_apple_on_january_first)

    NutritionFactsService.update(:meals)

    meal.reload

    assert_equal 180, meal.kcal
    assert_equal 180, meal.carbs
    assert_equal 18.0, meal.carbs_sugar_part
    assert_equal 180, meal.protein
    assert_equal 180, meal.fat
    assert_equal 18.0, meal.fat_saturated
    assert_equal 180, meal.fiber
  end

  test '.update(:journal_days)' do
    journal_day = journal_days(:john_january_first)

    NutritionFactsService.update(:journal_days)

    journal_day.reload

    assert_equal 196, journal_day.kcal
    assert_equal 196, journal_day.carbs
    assert_equal 19.6, journal_day.carbs_sugar_part
    assert_equal 196, journal_day.protein
    assert_equal 196, journal_day.fat
    assert_equal 19.6, journal_day.fat_saturated
    assert_equal 196, journal_day.fiber
  end
end
