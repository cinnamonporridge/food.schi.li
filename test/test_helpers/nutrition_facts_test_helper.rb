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

  def assert_correct_nutrition_facts(expected, actual)
    actual.reload
    assert_correct_nutrition_fact(expected, actual, :kcal)
    assert_correct_nutrition_fact(expected, actual, :carbs)
    assert_correct_nutrition_fact(expected, actual, :carbs_sugar_part)
    assert_correct_nutrition_fact(expected, actual, :protein)
    assert_correct_nutrition_fact(expected, actual, :fat)
    assert_correct_nutrition_fact(expected, actual, :fat_saturated)
    assert_correct_nutrition_fact(expected, actual, :fiber)
  end

  def assert_correct_nutrition_fact(expected, actual, fact_name)
    assert_not_equal FALSE_NUTRITION_FACTS[fact_name], actual[fact_name]
    assert_equal expected[fact_name], actual[fact_name]
  end

  def assert_false_nutrition_facts(actual)
    actual.reload
    assert_equal FALSE_NUTRITION_FACTS[:kcal], actual[:kcal]
    assert_equal FALSE_NUTRITION_FACTS[:carbs], actual[:carbs]
    assert_equal FALSE_NUTRITION_FACTS[:carbs_sugar_part], actual[:carbs_sugar_part]
    assert_equal FALSE_NUTRITION_FACTS[:protein], actual[:protein]
    assert_equal FALSE_NUTRITION_FACTS[:fat], actual[:fat]
    assert_equal FALSE_NUTRITION_FACTS[:fat_saturated], actual[:fat_saturated]
    assert_equal FALSE_NUTRITION_FACTS[:fiber], actual[:fiber]
  end
end
