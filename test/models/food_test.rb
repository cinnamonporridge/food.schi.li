require 'test_helper'

class FoodTest < ActiveSupport::TestCase
  test 'creates default portion before create' do
    food = users(:global).foods.new(name: 'Tomato', unit: 'gram',
                                    kcal: 0, carbs: 0, carbs_sugar_part: 0, protein: 0,
                                    fat: 0, fat_saturated: 0, fiber: 0)

    assert food.save
    assert_equal 1, food.portions.count
    food.portions.first.tap do |portion|
      assert_equal '100g', portion.name
      assert_equal 100, portion.amount
    end
  end
end
