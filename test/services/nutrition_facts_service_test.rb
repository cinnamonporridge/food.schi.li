require 'test_helper'

class NutritionFactsServiceTest < ActiveSupport::TestCase
  test '.update(:portions)' do
    portion = portions(:regular_banana_portion)

    truncate_nutrition_facts!(portion)

    NutritionFactsService.new(user: users(:daisy)).update!(:portions)

    portion.reload

    assert_equal 104, portion.kcal
    assert_in_delta(104.4, portion.carbs)
    assert_in_delta(10.44, portion.carbs_sugar_part)
    assert_in_delta(104.4, portion.protein)
    assert_in_delta(104.4, portion.fat)
    assert_in_delta(10.44, portion.fat_saturated)
    assert_in_delta(104.4, portion.fiber)
  end

  test '.update(:ingredients)' do
    ingredient = ingredients(:peanut_butter_in_vegan_peanut_butter_banana)

    truncate_nutrition_facts!(ingredient)

    NutritionFactsService.new(user: users(:daisy)).update!(:ingredients)

    ingredient.reload

    assert_equal 400, ingredient.kcal
    assert_in_delta(399.6, ingredient.carbs)
    assert_in_delta(39.6, ingredient.carbs_sugar_part)
    assert_in_delta(399.6, ingredient.protein)
    assert_in_delta(399.6, ingredient.fat)
    assert_in_delta(39.6, ingredient.fat_saturated)
    assert_in_delta(399.6, ingredient.fiber)
  end

  test '.update(:recipes)' do
    recipe = recipes(:apple_pie)

    truncate_nutrition_facts!(recipe)

    NutritionFactsService.new(user: users(:daisy)).update!(:recipes)

    recipe.reload

    assert_equal 54, recipe.kcal
    assert_equal 54, recipe.carbs
    assert_in_delta(5.4, recipe.carbs_sugar_part)
    assert_equal 54, recipe.protein
    assert_equal 54, recipe.fat
    assert_in_delta(5.4, recipe.fat_saturated)
    assert_equal 54, recipe.fiber
  end

  test '.update(:meals)' do
    meal = meals(:daisys_apple_pie_meal_on_february_fifth)

    truncate_nutrition_facts!(meal)

    NutritionFactsService.new(user: users(:daisy)).update!(:meals)

    meal.reload

    assert_equal 54, meal.kcal
    assert_in_delta(54.0, meal.carbs)
    assert_in_delta(5.4, meal.carbs_sugar_part)
    assert_in_delta(54.0, meal.protein)
    assert_in_delta(54.0, meal.fat)
    assert_in_delta(5.4, meal.fat_saturated)
    assert_in_delta(54.0, meal.fiber)
  end

  test '.update(:meal_ingredients)' do
    meal_ingredient = meal_ingredients(:johns_apple_on_january_first)

    truncate_nutrition_facts!(meal_ingredient)

    NutritionFactsService.new(user: users(:daisy)).update!(:meal_ingredients)

    meal_ingredient.reload

    assert_equal 180, meal_ingredient.kcal
    assert_equal 180, meal_ingredient.carbs
    assert_in_delta(18.0, meal_ingredient.carbs_sugar_part)
    assert_equal 180, meal_ingredient.protein
    assert_equal 180, meal_ingredient.fat
    assert_in_delta(18.0, meal_ingredient.fat_saturated)
    assert_equal 180, meal_ingredient.fiber
  end

  test '.update(:journal_days)' do
    journal_day = journal_days(:john_january_first)

    truncate_nutrition_facts!(journal_day)

    NutritionFactsService.new(user: users(:daisy)).update!(:journal_days)

    journal_day.reload

    assert_equal 196, journal_day.kcal
    assert_equal 196, journal_day.carbs
    assert_in_delta(19.6, journal_day.carbs_sugar_part)
    assert_equal 196, journal_day.protein
    assert_equal 196, journal_day.fat
    assert_in_delta(19.6, journal_day.fat_saturated)
    assert_equal 196, journal_day.fiber
  end

  test '.update(:journal_days), no meal_ingredients' do
    journal_day = journal_days(:john_january_first)
    journal_day.meals.destroy_all

    fake_nutrition_facts!(journal_day)

    NutritionFactsService.new(user: users(:daisy)).update!(:journal_days)

    journal_day.reload

    assert_equal 0, journal_day.kcal
    assert_equal 0, journal_day.carbs
    assert_in_delta(0, journal_day.carbs_sugar_part)
    assert_equal 0, journal_day.protein
    assert_equal 0, journal_day.fat
    assert_in_delta(0, journal_day.fat_saturated)
    assert_equal 0, journal_day.fiber
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

  def fake_nutrition_facts!(record)
    record.update!(
      kcal: 999,
      carbs: 999.9,
      carbs_sugar_part: 999.9,
      protein: 999.9,
      fat: 999.9,
      fat_saturated: 999.9,
      fiber: 999.9
    )
  end
end
