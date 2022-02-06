require 'test_helper'

class Recipe::NewIngredientFormComponentTest < ViewComponent::TestCase
  test '#render, only search field' do
    user = users(:daisy)
    recipe_ingredient = RecipeIngredient.new(recipe: recipes(:apple_pie))
    params = ActionController::Parameters.new(action_url: '/foo')
    render_inline new_component(user:, recipe_ingredient:, params:)

    assert_field 'Search food'
    assert_no_button 'Add ingredient'
  end

  test '#render' do
    user = users(:daisy)
    recipe_ingredient = RecipeIngredient.new(recipe: recipes(:apple_pie))
    params = ActionController::Parameters.new(action_url: '/foo', food_name: 'Banana')
    render_inline new_component(user:, recipe_ingredient:, params:)

    assert_field 'Search food'
    assert_button 'Add ingredient'
  end
end
