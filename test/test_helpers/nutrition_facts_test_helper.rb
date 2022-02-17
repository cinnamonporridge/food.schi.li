module NutritionFactsTestHelper
  MODELS_WITH_COMPUTED_NUTRITION_FACTS = [
    Portion,
    RecipeIngredient,
    Recipe,
    MealIngredient,
    Meal,
    JournalDay
  ].freeze

  FALSE_NUTRITION_FACTS = {
    kcal: 9999,
    carbs: 9999,
    carbs_sugar_part: 999.9,
    protein: 9999,
    fat: 9999,
    fat_saturated: 999.9,
    fiber: 9999
  }.freeze

  def falsify_all_nutrition_facts!
    MODELS_WITH_COMPUTED_NUTRITION_FACTS.map(&method(:falsify_model_nutrition_facts!))
  end

  def falsify_model_nutrition_facts!(model)
    model.update!(FALSE_NUTRITION_FACTS)
  end

  def assert_nutrition_facts_equal(expected, actual)
    actual.reload
    assert_equal(expected[:kcal], actual[:kcal], info_about_object(actual))
    assert_equal(expected[:carbs], actual[:carbs], info_about_object(actual))
    assert_equal(expected[:carbs_sugar_part], actual[:carbs_sugar_part], info_about_object(actual))
    assert_equal(expected[:protein], actual[:protein], info_about_object(actual))
    assert_equal(expected[:fat], actual[:fat], info_about_object(actual))
    assert_equal(expected[:fat_saturated], actual[:fat_saturated], info_about_object(actual))
    assert_equal(expected[:fiber], actual[:fiber], info_about_object(actual))
  end

  def with_snapshots(fixtures = {}, &)
    targets = fixtures.each_with_object({}) do |(key, fixture), hash|
      hash[key] = { snapshot: fixture.dup, original: fixture }
    end

    yield targets
  end

  def assert_original_equals_snapshot(target)
    assert_nutrition_facts_equal(target[:snapshot], target[:original])
  end

  def assert_original_equals_false(target)
    assert_nutrition_facts_equal(FALSE_NUTRITION_FACTS, target[:original])
  end

  private

  def info_about_object(object)
    "*** Object ***\n#{object.inspect}"
  end
end
