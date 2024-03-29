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

  def assert_nutrition_facts_equal(expected, actual) # rubocop:disable Metrics/AbcSize
    actual.reload

    assert_equal(expected[:kcal], actual[:kcal], object_info(actual))
    assert_in_delta(expected[:carbs], actual[:carbs], 0.1, object_info(actual))
    assert_in_delta(expected[:carbs_sugar_part], actual[:carbs_sugar_part], 0.1, object_info(actual))
    assert_in_delta(expected[:protein], actual[:protein], 0.1, object_info(actual))
    assert_in_delta(expected[:fat], actual[:fat], 0.1, object_info(actual))
    assert_in_delta(expected[:fat_saturated], actual[:fat_saturated], 0.1, object_info(actual))
    assert_in_delta(expected[:fiber], actual[:fiber], 0.1, object_info(actual))
  end

  def with_snapshots(fixtures = {}, &)
    targets = fixtures.transform_values(&method(:to_snapshot_hash))
    yield targets
  end

  def assert_original_equals_snapshot(target)
    assert_nutrition_facts_equal(target[:snapshot], target[:original])
  end

  def assert_original_equals_false(target)
    assert_nutrition_facts_equal(FALSE_NUTRITION_FACTS, target[:original])
  end

  private

  def object_info(object)
    "*** Object ***\n#{object.inspect}"
  end

  def to_snapshot_hash(value)
    { snapshot: value.dup, original: value }
  end
end
