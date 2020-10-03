require 'test_helper'

class NutritionFactsServiceTest < ActiveSupport::TestCase
  test '.promote_to_portions' do
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
end
