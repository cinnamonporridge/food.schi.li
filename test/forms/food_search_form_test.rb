require 'test_helper'

class FoodSearchFormTest < ActiveSupport::TestCase
  test 'params' do
    form = FoodSearchForm.new({ food_name: 'Mango', action_url: '/foo' }, users(:daisy))
    assert_equal 'Mango', form.food_name
    assert_equal '/foo', form.action_url
  end

  test '#no_foods_found?' do
    form = FoodSearchForm.new({ food_name: 'Magno', action_url: '/foo' }, users(:daisy))
    assert form.no_foods_found?
  end

  test '#food, distinct food' do
    form = FoodSearchForm.new({ food_name: 'Apple', action_url: '/foo' }, users(:daisy))
    assert_equal foods(:apple), form.food
  end

  test '#food, new food' do
    form = FoodSearchForm.new({ food_name: 'Does not exist', action_url: '/foo' }, users(:daisy))
    assert form.food.new_record?
  end

  test '#search_results' do
    form = FoodSearchForm.new({ food_name: 'na', action_url: '/foo' }, users(:daisy))
    assert_equal 2, form.search_results.count
  end

  test '#food_datalist_options' do
    form = FoodSearchForm.new({ action_url: '/foo' }, users(:daisy))
    assert_includes form.food_datalist_options, 'Apple'
    assert_not_includes form.food_datalist_options, 'Apricot'

    form = FoodSearchForm.new({ action_url: '/foo' }, users(:john))
    assert_includes form.food_datalist_options, 'Apricot'
    assert_not_includes form.food_datalist_options, 'Apple'
  end
end
