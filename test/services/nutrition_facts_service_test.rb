require 'test_helper'

class NutritionFactsServiceTest < ActiveSupport::TestCase
  setup do
    @portion = portions(:big_apple_portion)
    @recipe_ingredient = recipe_ingredients(:apples_in_apple_pie)
    @recipe = recipes(:apple_pie)
    @meal_ingredient = meal_ingredients(:daisys_apples_from_apple_pie_on_february_fifth)
    @meal = meals(:daisys_apple_pie_meal_on_february_fifth)
    @journal_day = journal_days(:daisy_february_fifth)
  end

  test '.update_track!(:portions)' do
    fake_all_nutrition_facts!

    NutritionFactsService.new(user: users(:daisy)).update_track!(:portions)

    assert_portion_nutrition_facts
    assert_ingredient_nutrition_facts
    assert_recipe_nutrition_facts
    assert_meal_ingredient_nutrition_facts
    assert_meal_nutrition_facts
    assert_journal_day_nutrition_facts
  end

  test '.update_track!(:recipes)' do
    fake_nutrition_facts!(@recipe_ingredient)
    fake_nutrition_facts!(@recipe)

    NutritionFactsService.new(user: users(:daisy)).update_track!(:portions)
    assert_ingredient_nutrition_facts
    assert_recipe_nutrition_facts
  end

  test '.update_track!(:recipes), no recipe_ingredients' do
    fake_nutrition_facts!(@recipe)
    @recipe.recipe_ingredients.delete_all

    NutritionFactsService.new(user: users(:daisy)).update_track!(:recipes)

    assert_nutrition_facts(
      @recipe,
      kcal: 0,
      carbs: 0.0,
      carbs_sugar_part: 0.0,
      protein: 0.0,
      fat: 0.0,
      fat_saturated: 0.0,
      fiber: 0.0
    )
  end

  test '.update_track!(:meals)' do
    fake_nutrition_facts!(@meal_ingredient)
    fake_nutrition_facts!(@meal)
    fake_nutrition_facts!(@journal_day)

    NutritionFactsService.new(user: users(:daisy)).update_track!(:meals)
    assert_meal_ingredient_nutrition_facts
    assert_meal_nutrition_facts
    assert_journal_day_nutrition_facts
  end

  test '.update_track!(:meals), no meal_ingredients' do
    fake_nutrition_facts!(@meal)
    @meal.meal_ingredients.delete_all

    NutritionFactsService.new(user: users(:daisy)).update_track!(:meals)

    assert_nutrition_facts(
      @meal,
      kcal: 0,
      carbs: 0.0,
      carbs_sugar_part: 0.0,
      protein: 0.0,
      fat: 0.0,
      fat_saturated: 0.0,
      fiber: 0.0
    )
  end

  test '.update_track!(:meals), no meals' do
    @journal_day.meals.destroy_all
    fake_nutrition_facts!(@journal_day)

    NutritionFactsService.new(user: users(:daisy)).update_track!(:meals)
    assert_nutrition_facts(
      @journal_day,
      kcal: 0,
      carbs: 0.0,
      carbs_sugar_part: 0.0,
      protein: 0.0,
      fat: 0.0,
      fat_saturated: 0.0,
      fiber: 0.0
    )
  end

  private

  def assert_portion_nutrition_facts
    assert_nutrition_facts(
      @portion,
      kcal: 200,
      carbs: 200.0,
      carbs_sugar_part: 20.00,
      protein: 200.0,
      fat: 200.0,
      fat_saturated: 20.00,
      fiber: 200.0
    )
  end

  def assert_ingredient_nutrition_facts
    assert_nutrition_facts(
      @recipe_ingredient,
      kcal: 6,
      carbs: 6.0,
      carbs_sugar_part: 0.6,
      protein: 6.0,
      fat: 6.0,
      fat_saturated: 0.6,
      fiber: 6.0
    )
  end

  def assert_recipe_nutrition_facts
    assert_nutrition_facts(
      @recipe,
      kcal: 54,
      carbs: 54,
      carbs_sugar_part: 5.4,
      protein: 54,
      fat: 54,
      fat_saturated: 5.4,
      fiber: 54
    )
  end

  def assert_meal_ingredient_nutrition_facts
    assert_nutrition_facts(
      @meal_ingredient,
      kcal: 6,
      carbs: 6.0,
      carbs_sugar_part: 0.6,
      protein: 6.0,
      fat: 6.0,
      fat_saturated: 0.6,
      fiber: 6.0
    )
  end

  def assert_meal_nutrition_facts
    assert_nutrition_facts(
      @meal,
      kcal: 54,
      carbs: 54.0,
      carbs_sugar_part: 5.4,
      protein: 54.0,
      fat: 54.0,
      fat_saturated: 5.4,
      fiber: 54.0
    )
  end

  def assert_journal_day_nutrition_facts
    assert_nutrition_facts(
      @journal_day,
      kcal: 54,
      carbs: 54.0,
      carbs_sugar_part: 5.4,
      protein: 54.0,
      fat: 54.0,
      fat_saturated: 5.4,
      fiber: 54.0
    )
  end

  def assert_nutrition_facts(record, expected_values = {})
    record.reload
    assert_nutrition_facts_equal(expected_values, record, :kcal)
    assert_nutrition_facts_in_delta(expected_values, record, :carbs)
    assert_nutrition_facts_in_delta(expected_values, record, :carbs_sugar_part)
    assert_nutrition_facts_in_delta(expected_values, record, :protein)
    assert_nutrition_facts_in_delta(expected_values, record, :fat)
    assert_nutrition_facts_in_delta(expected_values, record, :fat_saturated)
    assert_nutrition_facts_in_delta(expected_values, record, :fiber)
  end

  def assert_nutrition_facts_equal(expected_values, record, attribute)
    assert_equal(
      expected_values[attribute],
      record.read_attribute(attribute),
      ":#{attribute} of #{record.inspect}"
    )
  end

  def assert_nutrition_facts_in_delta(expected_values, record, attribute, delta = 0.001)
    assert_in_delta(
      expected_values[attribute],
      record.read_attribute(attribute),
      delta,
      ":#{attribute} of #{record.inspect}"
    )
  end

  def fake_all_nutrition_facts!
    fake_nutrition_facts!(@portion)
    fake_nutrition_facts!(@recipe_ingredient)
    fake_nutrition_facts!(@recipe)
    fake_nutrition_facts!(@meal_ingredient)
    fake_nutrition_facts!(@meal)
    fake_nutrition_facts!(@journal_day)
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
