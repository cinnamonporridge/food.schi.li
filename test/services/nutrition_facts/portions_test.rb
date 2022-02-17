require 'test_helper'

class NutritionFacts::PortionsTest < ActiveSupport::TestCase
  include NutritionFactsTestHelper

  test '.call! record is a Food' do
    with_snapshots(
      apple_default_portion: portions(:apple_default_portion),
      big_apple_portion: portions(:big_apple_portion),
      apricot_default_portion: portions(:apricot_default_portion)
    ) do |targets|
      falsify_all_nutrition_facts!
      new_object(record: foods(:apple)).call!

      assert_original_equals_snapshot targets[:apple_default_portion]
      assert_original_equals_snapshot targets[:big_apple_portion]
      assert_original_equals_false targets[:apricot_default_portion]
    end
  end

  test '.call! record is a Portion' do
    with_snapshots(
      apple_default_portion: portions(:apple_default_portion),
      big_apple_portion: portions(:big_apple_portion)
    ) do |targets|
      falsify_all_nutrition_facts!
      new_object(record: portions(:apple_default_portion)).call!

      assert_original_equals_snapshot targets[:apple_default_portion]
      assert_original_equals_false targets[:big_apple_portion]
    end
  end

  test '.call! record is a User' do
    with_snapshots(
      apple_default_portion: portions(:apple_default_portion),
      milk_default_portion: portions(:milk_default_portion),
      apricot_default_portion: portions(:apricot_default_portion)
    ) do |targets|
      falsify_all_nutrition_facts!
      new_object(record: users(:john)).call!

      assert_original_equals_false targets[:apple_default_portion]
      assert_original_equals_false targets[:milk_default_portion]
      assert_original_equals_snapshot targets[:apricot_default_portion]
    end
  end
end
