require 'test_helper'

class FoodSearchFormComponentTest < ViewComponent::TestCase
  test '#render, empty :food_name' do
    render_inline new_component(form: FoodSearchForm.new(Food.new, { action_url: 'foo' }))
    assert_not page.find_field('Search food').value.present?
  end

  test '#render, with :food_name' do
    render_inline new_component(form: FoodSearchForm.new(Food.new, { action_url: 'foo', food_name: 'Mango' }))
    assert_field 'Search food', with: 'Mango'
  end

  test '#render, with foods name' do
    render_inline new_component(form: FoodSearchForm.new(foods(:apple), { action_url: 'foo' }))
    assert_field 'Search food', with: 'Apple'
  end

  test '#food_datalist_options' do
    component = new_component(form: FoodSearchForm.new(foods(:apple), { action_url: 'foo' }))
    assert_includes component.food_datalist_options, 'Apple'
    assert_not_includes component.food_datalist_options,
                        'Apricot',
                        'Apricot belongs to John, but only Daisys foods should be listed'
  end
end
