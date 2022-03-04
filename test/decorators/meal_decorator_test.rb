require 'test_helper'

class MealDecoratorTest < ActiveSupport::TestCase
  test '#display_day_partition_name' do
    assert_equal 'Unpartitioned', meals(:daisys_big_apple_meal_on_february_first).decorate.display_day_partition_name
  end

  test '#display_name, recipe' do
    assert_equal 'Apple Pie', meals(:daisys_apple_pie_meal_on_february_fifth).decorate.display_name
  end

  test '#display_name, portion' do
    assert_equal 'Milk', meals(:daisys_glass_of_milk_meal_on_february_first).decorate.display_name
  end
end
