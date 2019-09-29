require 'test_helper'

class RecipeIngredientFlowsTest < ActionDispatch::IntegrationTest

  def setup
    login_user(users(:john))
  end

  test 'user adds a default ingredient to a recipe' do
    recipe = recipes(:apple_pie)
    ingredient_portion = portions(:sugar_default_portion)
    get recipe_path(recipe)
    assert_response :success

    assert_select 'a.primary.button', 'Add ingredient'
    get new_recipe_ingredient_path(recipe)
    assert_response :success
    assert_select 'h1', 'Add ingredient to Apple Pie'

    assert_select '#recipe_ingredient_portion_id'
    assert_select '#recipe_ingredient_amount_in_measure'
    assert_select '#recipe_ingredient_measure'

    post "/recipes/#{recipe.id}/ingredients",
      params: {
        recipe_ingredient: {
          portion_name: '',
          amount_in_measure: '',
          measure: ''
        }
      }
    assert_response :success
    assert_equal 'Invalid input', flash[:error]

    post "/recipes/#{recipe.id}/ingredients",
      params: {
        recipe_ingredient: {
          portion_name: 'Sugar (100g)',
          amount_in_measure: '500',
          measure: 'unit'
        }
      }
    follow_redirect!
    assert_response :success

    assert_equal 'Ingredient added', flash[:notice]
  end

  test 'user adds a pieces ingredient to a recipe' do
    recipe = recipes(:apple_pie)
    ingredient_portion = portions(:sugar_cube_portion)
    post "/recipes/#{recipe.id}/ingredients",
      params: {
        recipe_ingredient: {
          portion_name: 'Sugar Cube (25g)',
          amount_in_measure: '2',
          measure: 'piece'
        }
      }
    follow_redirect!
    assert_response :success

    assert_equal 'Ingredient added', flash[:notice]
  end

  test 'user edits an recipe ingredient' do
    ingredient = ingredients(:milk_in_apple_pie)
    get edit_recipe_ingredient_path(ingredient.recipe, ingredient)
    assert_response :success
    assert_select 'h1', "Edit ingredient for #{ingredient.recipe.name}"

    put "/recipes/#{ingredient.recipe.id}/ingredients/#{ingredient.id}",
      params: {
        recipe_ingredient: {
          portion_id_selection: 'Milk (100ml)',
          amount_in_measure: '60',
          measure: 'unit'
        }
      }
    follow_redirect!
    assert_response :success
    assert_equal 'Ingredient updated', flash[:notice]
  end

  test 'user deletes a recipe ingredient' do
    ingredient = ingredients(:milk_in_apple_pie)
    delete recipe_ingredient_path(ingredient.recipe, ingredient)
    follow_redirect!
    assert_response :success
    assert_equal 'Ingredient deleted', flash[:notice]
  end
end
