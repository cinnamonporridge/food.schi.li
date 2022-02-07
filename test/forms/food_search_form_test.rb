require 'test_helper'

class FoodSearchFormTest < ActiveSupport::TestCase
  test '#food_name, #action_url and #search_performed?' do
    form = FoodSearchForm.new(Food.new, { food_name: 'Mango', action_url: '/foo' })
    assert_equal 'Mango', form.food_name
    assert_equal '/foo', form.action_url
  end

  test '#food_name of object' do
    form = FoodSearchForm.new(foods(:apple), { action_url: '/foo' })
    assert_equal 'Apple', form.food_name
    assert_equal '/foo', form.action_url
  end

  test '#search_performed?' do
    form = FoodSearchForm.new(Food.new, { food_name: 'Apple', action_url: '/foo' })
    assert form.search_performed?

    form = FoodSearchForm.new(Food.new, { food_name: '', action_url: '/foo' })
    assert_not form.search_performed?
  end

  test '#food_not_found?' do
    form = FoodSearchForm.new(Food.new, { food_name: 'Magno', action_url: '/foo' })
    assert form.food_not_found?
  end
end
