require 'test_helper'

class NutritionFactsServiceTest < ActiveSupport::TestCase
  test '.update(:portions)' do
    portion = portions(:regular_banana_portion)

    truncate_nutrition_facts!(portion)

    NutritionFactsService.update(:portions)

    portion.reload

    assert_equal 104, portion.kcal
    assert_equal 104.4, portion.carbs
    assert_equal 10.44, portion.carbs_sugar_part
    assert_equal 104.4, portion.protein
    assert_equal 104.4, portion.fat
    assert_equal 10.44, portion.fat_saturated
    assert_equal 104.4, portion.fiber
  end

  test '.update(:ingredients)' do
    ingredient = ingredients(:peanut_butter_in_vegan_peanut_butter_banana)

    truncate_nutrition_facts!(ingredient)

    NutritionFactsService.update(:ingredients)

    ingredient.reload

    assert_equal 400, ingredient.kcal
    assert_equal 399.6, ingredient.carbs
    assert_equal 39.6, ingredient.carbs_sugar_part
    assert_equal 399.6, ingredient.protein
    assert_equal 399.6, ingredient.fat
    assert_equal 39.6, ingredient.fat_saturated
    assert_equal 399.6, ingredient.fiber
  end

  test '.update(:recipes)' do
    recipe = recipes(:apple_pie)

    truncate_nutrition_facts!(recipe)

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

    truncate_nutrition_facts!(meal)

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

    truncate_nutrition_facts!(journal_day)

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

  private

  def truncate_nutrition_facts!(record)
    record.update!(
      kcal: 0,
      carbs: 0.0,
      carbs_sugar_part: 0.0,
      protein: 0.0,
      fat: 0.0,
      fat_saturated: 0.0,
      fiber: 0.0
    )
  end
end
