require 'test_helper'

class FoodSearchFormTest < ActiveSupport::TestCase
  test 'params' do
    form = FoodSearchForm.new({ food_name: 'Mango', action_url: '/foo' }, users(:daisy))
    assert_equal 'Mango', form.food_name
    assert_equal '/foo', form.action_url
  end

  test '#no_foods_found?' do
    form = FoodSearchForm.new({ food_name: 'Magno', action_url: '/foo' }, users(:daisy))
    assert_predicate form, :no_foods_found?
  end

  test '#food, global food, as admin' do
    form = FoodSearchForm.new({ food_name: 'Banana', action_url: '/foo' }, users(:daisy))
    assert_equal foods(:banana), form.food
  end

  test '#food, global food, as user' do
    form = FoodSearchForm.new({ food_name: 'Banana', action_url: '/foo' }, users(:john))
    assert_equal foods(:banana), form.food
  end

  test '#food, own food' do
    form = FoodSearchForm.new({ food_name: 'Milk', action_url: '/foo' }, users(:daisy))
    assert_equal foods(:milk), form.food
  end

  test '#food, other food not found' do
    food = foods(:maple_syrup) # belongs to john
    form = FoodSearchForm.new({ food_name: food.name, action_url: '/foo' }, users(:daisy))
    assert_predicate form.food, :new_record?
  end

  test '#food, new food' do
    form = FoodSearchForm.new({ food_name: 'Does not exist', action_url: '/foo' }, users(:daisy))
    assert_predicate form.food, :new_record?
  end

  test '#search_results' do
    form = FoodSearchForm.new({ food_name: 'na', action_url: '/foo' }, users(:daisy))
    assert_equal 2, form.search_results.count
  end

  test '#food_datalist_options, as admin' do
    form = FoodSearchForm.new({ action_url: '/foo' }, users(:daisy))
    assert_includes form.food_datalist_options, 'Apple'
    assert_not_includes form.food_datalist_options, 'Maple Syrup'
    assert_includes form.food_datalist_options, 'Milk'
  end

  test '#food_datalist_options, as user' do
    form = FoodSearchForm.new({ action_url: '/foo' }, users(:john))
    assert_includes form.food_datalist_options, 'Maple Syrup'
    assert_includes form.food_datalist_options, 'Apple'
    assert_not_includes form.food_datalist_options, 'Milk'
  end
end
