require 'test_helper'

class NutritionFacts::PortionsTest < ActiveSupport::TestCase
  include NutritionFactsTestHelper

  setup do
    @original_apple_default_portion = portions(:apple_default_portion).dup
    @original_big_apple_portion = portions(:big_apple_portion).dup
    @original_apricot_default_portion = portions(:apricot_default_portion).dup
  end

  test '.call! record is a Food' do
    falsify_all_nutrition_facts!
    klass.new(record: foods(:apple)).call!

    assert_correct_nutrition_facts(@original_apple_default_portion, portions(:apple_default_portion))
    assert_correct_nutrition_facts(@original_big_apple_portion, portions(:big_apple_portion))
    assert_false_nutrition_facts(portions(:apricot_default_portion))
  end

  test '.call! record is a Portion' do
    falsify_all_nutrition_facts!
    klass.new(record: portions(:apple_default_portion)).call!

    assert_correct_nutrition_facts(@original_apple_default_portion, portions(:apple_default_portion))
    assert_false_nutrition_facts(portions(:big_apple_portion))
  end

  test '.call! record is a User' do
    falsify_all_nutrition_facts!
    klass.new(record: users(:john)).call!

    assert_false_nutrition_facts(portions(:apple_default_portion))
    assert_false_nutrition_facts(portions(:milk_default_portion))
    assert_correct_nutrition_facts(@original_apricot_default_portion, portions(:apricot_default_portion))
  end
end
