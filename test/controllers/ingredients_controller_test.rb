require 'test_helper'

class IngredientsControllerTest < ActionDispatch::IntegrationTest

  def setup
    login_user(users(:john))
  end

  test 'decimal amount is allowed' do
    recipe = recipes(:apple_pie)
    portion = portions(:sugar_cube_portion)

    assert_difference('Ingredient.count') do
      post recipe_ingredients_path(recipe), 
        params: {
          recipe_ingredient: {
            portion_id: portion.id,
            amount_in_measure: '1.77',
            measure: 'piece'
          }
        }
    end

    # 1.77 pieces of 25g sugar cube = 44.25g
    recipe.reload
    assert_equal 44.25, recipe.ingredients.find_by(portion: portion).amount
  end
end