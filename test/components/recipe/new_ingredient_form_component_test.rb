require 'test_helper'

class Recipe::NewIngredientFormComponentTest < ViewComponent::TestCase
  test '#render, only search field' do
    recipe = recipes(:apple_pie)
    params = ActionController::Parameters.new(action_url: '/foo')
    render_inline new_component(recipe:, params:)

    assert_field 'Search food'
    assert_no_button 'Add ingredient'
  end

  test '#render' do
    recipe = recipes(:apple_pie)
    params = ActionController::Parameters.new(action_url: '/foo', food_name: 'Banana')
    render_inline new_component(recipe:, params:)

    assert_field 'Search food'
    assert_button 'Add ingredient'
  end
end
