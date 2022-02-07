require 'test_helper'

class RecipeIngredientFormComponentTest < ViewComponent::TestCase
  test '#render, new recipe ingredient' do
    recipe_ingredient = recipes(:apple_pie).recipe_ingredients.new
    recipe_ingredient.portion = portions(:sugar_cube_portion)
    form = RecipeIngredientForm.new(recipe_ingredient)
    render_inline new_component(form:)
    assert_checked_field 'Sugar Cube'
    assert_field 'Amount in measure', with: '0.0'
    assert_button 'Add ingredient'
  end

  test '#render, existing recipe ingredient' do
    recipe_ingredient = recipe_ingredients(:apples_in_apple_pie)
    form = RecipeIngredientForm.new(recipe_ingredient)
    render_inline new_component(form:)
    assert_checked_field 'Apple Big Apple'
    assert_field 'Amount in measure', with: '0.03'
    assert_button 'Update ingredient'
  end

  test 'not #render, food not persisted' do
    recipe_ingredient = recipes(:apple_pie).recipe_ingredients.new
    recipe_ingredient.food = users(:daisy).foods.new
    form = RecipeIngredientForm.new(recipe_ingredient)
    component = new_component(form:)
    assert_not component.render?
  end
end
